import SwiftUI

struct SearchResultFactoryImpl: SearchResultFactory {
   
    let usecase: any FetchSearchResultUseCase
    
    init(usecase: any FetchSearchResultUseCase) {
        self.usecase = usecase
    }
    
    
    public func makeView(text: String) -> some View {
        
        let viewModel = ResultViewModel(text: text, fetchSearchResultUseCase: usecase)
        
        return ResultView(viewModel: viewModel)
    }
    

}
