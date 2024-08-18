import SwiftUI
import Combine



struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel
    
    let resultViewFactory: any SearchResultFactory
    
    let datas: [Int] = [1,2,3,4,5]
    
    init(
        viewModel: SearchViewModel,
        resultViewFactory: any SearchResultFactory) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.resultViewFactory = resultViewFactory
    }
    

   
    
    var body: some View {
        
        NavigationStack(path: $viewModel.path, root: {
            List(0..<10) { row in
                Text("\(row)")
            }
            .listStyle(.plain)
            .navigationTitle("Search")
        })
        .navigationDestination(for:SearchNavigation.self, destination: { navigation  in
            switch navigation.name {
            case .result:
                EmptyView()
               
            }
            
        })
        .searchable(
            text: $viewModel.querySstring, 
            placement: .navigationBarDrawer,
            prompt: "검색어를 입력해주세요."
        )
        .onSubmit(of: .search){
            viewModel.searchButtonDidTap.send(())
            print("검색 버튼 탭")
        }
        
    }
}

#Preview {
    
    SearchView(viewModel: SearchViewModel(), resultViewFactory: SearchResultComponent(usecase: FetchSearchResultUseCaseSpy()))
}
