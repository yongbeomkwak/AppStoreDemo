import SwiftUI
import Combine



struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
   
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    
    SearchView(viewModel: SearchViewModel(fetchSearchResultUseCase: FetchSearchResultUseCaseSpy()))
}
