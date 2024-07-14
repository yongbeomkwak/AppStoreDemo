import Combine
import Foundation

public protocol RemoteSearchDataSource {
    func fetchSearchResult(text: String, limit: Int) -> AnyPublisher<SearchResultEntity,NetworkingError>
}
