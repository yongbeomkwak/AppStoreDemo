import Foundation
import Combine

final class RemoteSearchDataSourceImpl: RemoteSearchDataSource {
    
    private let networking: any CombineNetworking
    
    init(networking: any CombineNetworking = CombineNetworkingImpl(client: .init())) {
        self.networking = networking
    }
    
    func fetchSearchResult(text: String, limit: Int) -> AnyPublisher<SearchResultEntity, NetworkingError> {
        
        
        networking.request(SearchAPI.fetchSearchItem(text: text, limit: limit),dto: SearchResultResponseDTO.self)
            .map{$0.toDomain()}
            .eraseToAnyPublisher()
    }
    
    
}
