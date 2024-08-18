import Foundation
import Combine

final class SearchViewModel: ObservableObject  {
        
    private let subscription: Set<AnyCancellable> = Set<AnyCancellable>()
    private let fetchSearchResultUseCase: any FetchSearchResultUseCase
    
    
    
    init(fetchSearchResultUseCase: any FetchSearchResultUseCase) {
        self.fetchSearchResultUseCase = fetchSearchResultUseCase
        
    }
     
    
}
