import Foundation
import Combine

public protocol FetchSearchResultUseCase {
    func execute(text: String, limit: Int) -> AnyPublisher<SearchResultEntity,NetworkingError>
    
}
