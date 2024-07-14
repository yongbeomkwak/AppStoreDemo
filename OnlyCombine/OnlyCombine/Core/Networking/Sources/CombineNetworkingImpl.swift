import Foundation
import Combine

final class CombineNetworkingImpl: CombineNetworking {

    
        
    typealias Endpoint = AnyEndpoint
    private let client: CAlamofireClient<Endpoint>

    init(client: CAlamofireClient<Endpoint>) {
        self.client = client
    }
     
    
    func request<T>(_ endpoint: any EndpointType, dto: T.Type) -> AnyPublisher<T, NetworkingError> where T : Decodable {
        let newEndpoint = AnyEndpoint.endpoint(endpoint)
        
        return performRequest(newEndpoint)
            .map(\.data)
            .decode(type: dto, decoder: JSONDecoder())
            .mapError({ error in
                NetworkingError.decodingError
            })
            .eraseToAnyPublisher()
    }
    

}

private extension CombineNetworkingImpl {
    @discardableResult
    func performRequest(_ endpoint: Endpoint)  ->  AnyPublisher<DataResponse, NetworkingError> {
        
        client.requestPublisher(endpoint)
            .mapError { error -> NetworkingError in
                guard case CAlamofireError.statusCode(error.response) = error,
                      let httpResponse = error.response?.request as? HTTPURLResponse
                      
                else {
                    return NetworkingError.internalServerError
                }

                return NetworkingError(statusCode: httpResponse.statusCode)
            }
            .eraseToAnyPublisher()
            
        

    }
}
