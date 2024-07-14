import Foundation
import Combine

final class SearchRepositoryImpl: SearchRepository {
    
    private let remoteSearchDataSource: any RemoteSearchDataSource
    
    
    init(remoteSearchDataSource: any RemoteSearchDataSource) {
        self.remoteSearchDataSource = remoteSearchDataSource
    }
    
    func fetchSearchResult(text: String, limit: Int) -> AnyPublisher<SearchResultEntity, NetworkingError> {
        remoteSearchDataSource.fetchSearchResult(text: text, limit: limit)
    }
    
}
