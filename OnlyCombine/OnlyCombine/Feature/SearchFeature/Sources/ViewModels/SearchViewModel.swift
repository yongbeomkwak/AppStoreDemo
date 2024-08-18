import Foundation
import Combine
import SwiftUI

final class SearchViewModel: BaseViewModel  {
        
   
    
    @Published var path = NavigationPath()
    @Published var querySstring: String = ""
    var searchButtonDidTap: PassthroughSubject<Void, Never> = .init()
    
    
    override init() {
        super.init()
        bind()
    }
    
    
    override func bind() {
        
        searchButtonDidTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.path.append(SearchNavigation(name: .result))
            }
            .store(in: &subscription)
        
    }
    
    
}
