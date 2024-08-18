import Foundation
import SwiftUI
import Swinject

struct SearchAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(SearchView.self){ r  in
            let usecase = container.resolve(FetchSearchResultUseCase.self)!
            
            return SearchView(viewModel: SearchViewModel(fetchSearchResultUseCase: usecase))
        }
    }
    
}
