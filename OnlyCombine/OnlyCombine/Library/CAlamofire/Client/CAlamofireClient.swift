import Combine
import Foundation

open class CAlamofireClient<Endpoint: EndpointType>: CAlamofireClientProtocol {
    private var interceptors: [any InterceptorType] = []

    public init(interceptors: [any InterceptorType] = []) {
        self.interceptors = interceptors
    }

    public func setInterceptors(interceptors: [any InterceptorType]) {
        self.interceptors = interceptors
    }

    public func addInterceptor(interceptor: any InterceptorType) {
        self.interceptors.append(interceptor)
    }

    public func removeAllInterceptor() {
        self.interceptors.removeAll()
    }

    open func request(
        _ endpoint: Endpoint,
        completion: @escaping (Result<DataResponse, CAlamofireError>) -> Void
    ) {
        do {
            let request = try configureURLRequest(from: endpoint)
            interceptRequest(
                request,
                endpoint: endpoint,
                using: self.interceptors
            ) { [weak self] result in
                guard let self = self else {
                    completion(.failure(CAlamofireError.notFoundOwner))
                    return
                }
                switch result {
                case let .success(request):
                    self.requestNetworking(request, endpoint: endpoint, completion: completion)

                case let .failure(error):
                    if let emdpointError = error as? CAlamofireError {
                        completion(.failure(emdpointError))
                        return
                    }
                    completion(.failure(CAlamofireError.underlying(error)))
                }
            }
            
        } catch {
            if let emdpointError = error as? CAlamofireError {
                completion(.failure(emdpointError))
                return
            }
            completion(.failure(CAlamofireError.underlying(error)))
        }
    }

    open func request(_ endpoint: Endpoint) async throws -> DataResponse {
        
        /// withCheckedThrowingContinuation는 Swift의 Concurrency 모듈에서 사용되는 함수로, 비동기 작업을 동기 코드처럼 처리할 수 있게 도와줍니다. 이 함수는 비동기 코드에서 발생하는 예외를 처리할 수 있도록 설계된 예외를 던지는 continuation을 제공합니다.

        // 주요 기능 및 역할
        /// withCheckedThrowingContinuation는 비동기 API를 호출하고, 그 결과를 기다려야 하는 경우에 유용합니다. 특히, 비동기 API가 콜백을 사용하여 결과를 반환하는 경우, 이를 비동기 함수로 쉽게 변환할 수 있습니다.
        try await withCheckedThrowingContinuation { config in
            self.request(endpoint, completion: config.resume(with:))
        }
    }

    open func requestPublisher(
        _ endpoint: Endpoint
    ) -> AnyPublisher<DataResponse, CAlamofireError> {
        Deferred { // 지연된 publisher
            Future { fulfill in
                self.request(endpoint, completion: fulfill)
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension CAlamofireClient {
    func configureURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        let requestURL: URL = URL(endpoint: endpoint)
        var request = URLRequest(
            url: requestURL,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: endpoint.timeout
        )
        request.httpMethod = endpoint.route.method

        try endpoint.task.configureRequest(request: &request)

        if let headers = endpoint.headers {
            headers.forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            }
        }

        return request
    }

    func requestNetworking(
        _ request: URLRequest,
        endpoint: Endpoint,
        completion: @escaping (Result<DataResponse, CAlamofireError>) -> Void
    ) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                if let emdpointError = error as? CAlamofireError {
                    completion(.failure(emdpointError))
                    return
                }
                completion(.failure(CAlamofireError.underlying(error)))
                return
            }

            if let response {
                let dataResponse = DataResponse(
                    request: request,
                    data: data ?? .init(),
                    response: response
                )
                self.interceptResponse(
                    response: .success(dataResponse),
                    endpoint: endpoint,
                    using: self.interceptors,
                    completion: completion
                )
                return
            }

            completion(.failure(CAlamofireError.networkError))
        }.resume()
    }

    // MARK: - Interceptor
    func interceptRequest(
        _ request: URLRequest,
        endpoint: EndpointType,
        using interceptors: [any InterceptorType],
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var pendingInterceptors = interceptors
        guard !pendingInterceptors.isEmpty else {
            completion(.success(request))
            return
        }

        let interceptor = pendingInterceptors.removeFirst()
        interceptor.willRequest(request, endpoint: endpoint)
        interceptor.prepare(request, endpoint: endpoint) { [weak self] result in
            guard let self = self else {
                completion(.failure(CAlamofireError.notFoundOwner))
                return
            }
            switch result {
            case let .success(newRequest):
                self.interceptRequest(
                    newRequest,
                    endpoint: endpoint,
                    using: pendingInterceptors,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func interceptResponse(
        response: Result<DataResponse, CAlamofireError>,
        endpoint: EndpointType,
        using interceptors: [any InterceptorType],
        completion: @escaping (Result<DataResponse, CAlamofireError>) -> Void
    ) {
        var pendingInterceptors = interceptors
        guard !pendingInterceptors.isEmpty else {
            if case let .success(response) = response,
               let httpResponse = response.response as? HTTPURLResponse,
               !(endpoint.validationCode ~= httpResponse.statusCode) {
                completion(.failure(CAlamofireError.statusCode(response)))
                return
            }
            completion(response)
            return
        }

        let interceptor = pendingInterceptors.removeFirst()
        interceptor.didReceive(response, endpoint: endpoint)
        interceptor.process(response, endpoint: endpoint) { [weak self] result in
            guard let self = self else {
                completion(.failure(CAlamofireError.notFoundOwner))
                return
            }
            switch result {
            case let .success(newResponse):
                if let httpResponse = newResponse.response as? HTTPURLResponse,
                   !(endpoint.validationCode ~= httpResponse.statusCode) {
                    self.interceptResponse(
                        response: .failure(CAlamofireError.statusCode(newResponse)),
                        endpoint: endpoint,
                        using: pendingInterceptors,
                        completion: completion
                    )
                    return
                }
                self.interceptResponse(
                    response: .success(newResponse),
                    endpoint: endpoint,
                    using: pendingInterceptors,
                    completion: completion
                )

            case let .failure(error):
                self.interceptResponse(
                    response: .failure(error),
                    endpoint: endpoint,
                    using: pendingInterceptors,
                    completion: completion
                )
            }
        }
    }
}
