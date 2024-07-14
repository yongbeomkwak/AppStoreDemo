import Foundation
import Combine

public protocol SearchRepository {
    func fetchSearchResult(text: String, limit: Int) -> AnyPublisher<SearchResultEntity,NetworkingError>
}
