import SwiftUI

struct ResultView: View {
    
    @StateObject var viewModel: ResultViewModel
    
    init(viewModel: ResultViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.results, id: \.self) { item in
            Text(item.appIcon)
        }
    }
}

#Preview {
    ResultView(viewModel: ResultViewModel(text: "123", fetchSearchResultUseCase: FetchSearchResultUseCaseSpy()))
}
