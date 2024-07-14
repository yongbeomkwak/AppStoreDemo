import Foundation
import Combine

final class CombineNetworkingImpl: CombineNetworking {

        
    typealias Endpoint = AnyEndpoint
    private let client: CAlamofireClient<Endpoint>

    init(client: CAlamofireClient<Endpoint>) {
        self.client = client
    }
     
    
    
    func request(_ endpoint: any EndpointType) -> AnyPublisher<Data, NetworkingError> {
        
        let newEndpoint = AnyEndpoint.endpoint(endpoint)
        return performRequest(newEndpoint)
            .map(\.data)
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
                    return NetworkingError.badRequest
                }

                return NetworkingError(statusCode: httpResponse.statusCode)
            }
            .eraseToAnyPublisher()
            
        

    }
}
