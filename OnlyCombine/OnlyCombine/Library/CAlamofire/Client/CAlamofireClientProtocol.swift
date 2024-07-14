import Combine
import Foundation

public protocol CAlamofireClientProtocol {
    associatedtype Endpoint: EndpointType

    func request(
        _ endpoint: Endpoint,
        completion: @escaping (Result<DataResponse, CAlamofireError>) -> Void
    )
    func request(_ endpoint: Endpoint) async throws -> DataResponse
    func requestPublisher(_ endpoint: Endpoint) -> AnyPublisher<DataResponse, CAlamofireError>
}
