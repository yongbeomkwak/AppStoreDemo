import Foundation
import SwiftUI
import Swinject

struct SearchAssembly: Assembly {
    func assemble(container: Container) {
        
        
        container.register((any SearchResultFactory).self) { _ in
          
            let usecase = container.resolve(FetchSearchResultUseCase.self)!
          
            
            return SearchResultComponent(usecase: usecase)
        }
    
        
        container.register(SearchView.self){ r  in
           
            let resultFactory = container.resolve((any SearchResultFactory).self)!
            
            return SearchView(viewModel: SearchViewModel(), resultViewFactory: resultFactory)
        }
        
        

    }
    
}
