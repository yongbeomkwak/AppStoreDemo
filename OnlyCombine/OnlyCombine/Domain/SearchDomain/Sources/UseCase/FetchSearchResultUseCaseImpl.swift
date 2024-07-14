import Foundation
import Combine

struct FetchSearchResultUseCaseImpl: FetchSearchResultUseCase {
    
    private let searchRepository: any SearchRepository

    init(searchRepository: any SearchRepository) {
        self.searchRepository = searchRepository
    }

    func execute(text: String, limit: Int) -> AnyPublisher<SearchResultEntity, NetworkingError> {
        searchRepository.fetchSearchResult(text: text, limit: limit)
    }
    
}
