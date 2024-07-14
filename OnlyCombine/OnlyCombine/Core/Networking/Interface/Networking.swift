import Combine
import Foundation


public protocol CombineNetworking {
    func request<T: Decodable>(_ endpoint: any EndpointType, dto: T.Type) -> Future<T, CAlamofireError>
    func request(_ endpoint: any EndpointType) ->  Future<Void, CAlamofireError>
}

public protocol ConcurrenyNetworking {
    func request<T: Decodable>(_ endpoint: any EndpointType, dto: T.Type) async throws -> T
    func request(_ endpoint: any EndpointType) async throws
}
