import Foundation

public protocol InterceptorType {
    func prepare(
        _ request: URLRequest,
        endpoint: EndpointType,
        completion: @escaping (Result<URLRequest, CAlamofireError>) -> Void
    )
    func willRequest(_ request: URLRequest, endpoint: EndpointType)
    func process(
        _ result: Result<DataResponse, CAlamofireError>,
        endpoint: EndpointType,
        completion: @escaping (Result<DataResponse, CAlamofireError>) -> Void
    )
    func didReceive(_ result: Result<DataResponse, CAlamofireError>, endpoint: EndpointType)
}

public extension InterceptorType {
    func prepare(
        _ request: URLRequest,
        endpoint: EndpointType,
        completion: @escaping (Result<URLRequest, CAlamofireError>) -> Void
    ) { completion(.success(request)) }
    func willRequest(_ request: URLRequest, endpoint: EndpointType) { }
    func process(
        _ result: Result<DataResponse, CAlamofireError>,
        endpoint: EndpointType,
        completion: @escaping (Result<DataResponse, CAlamofireError>) -> Void
    ) { completion(result) }
    func didReceive(_ result: Result<DataResponse, CAlamofireError>, endpoint: EndpointType) { }
}
