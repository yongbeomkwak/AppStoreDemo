import Foundation
import Combine

struct FetchSearchResultUseCaseSpy: FetchSearchResultUseCase {
    func execute(text: String, limit: Int) -> AnyPublisher<SearchResultEntity, NetworkingError> {
        
        let entity = SearchResultEntity.init(resultCount: 20, results: [SearchDetailEntity(trackID: 0, download: 123, rating: 4.5, appName: "Hello", appIcon: "123", description: "desc", userName: "Us", category: "cat1", screenshotUrls: [""])])
        
        let future = Future<SearchResultEntity, NetworkingError> { promise in
        
            promise(.success(entity))
            promise(.failure(.badRequest))
        }
        
        return future.eraseToAnyPublisher()
    }
}
