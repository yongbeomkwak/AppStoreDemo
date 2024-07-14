import Foundation
import Combine

final class RemoteSearchDataSourceImpl: RemoteSearchDataSource {
    
    private let networking: any CombineNetworking
    
    init(networking: any CombineNetworking = CombineNetworkingImpl(client: .init())) {
        self.networking = networking
    }
    
    func fetchSearchResult(text: String, limit: Int) -> AnyPublisher<SearchResultEntity, NetworkingError> {
        networking.request(SearchAPI.fetchSearchItem(text: text, limit: limit))
            .decode(type: SearchResultResponseDTO.self, decoder: JSONDecoder())
            .mapError({ error in
                NetworkingError.internalServerError
            })
            .map{$0.toDomain()}
            .eraseToAnyPublisher()
    }
    
    
}
