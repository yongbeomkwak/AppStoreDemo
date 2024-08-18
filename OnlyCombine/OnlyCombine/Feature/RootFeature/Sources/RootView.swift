import SwiftUI
import Swinject

struct RootView: View {
    
    let injector: Injector
    @StateObject var viewModel: RootViewModel
    
    init(injector: Injector) {
        self.injector = injector
        self._viewModel = .init(wrappedValue: RootViewModel())
    }
    
    var body: some View {
        
        ZStack {
            if viewModel.isLoading {
                Color(.black).opacity(viewModel.isLoading ? 1 : 0).ignoresSafeArea(.container)
            } else {
                injector.resolve(SearchView.self)
            }
        }
        .animation(.default, value: viewModel.isLoading)
    }
}

#Preview {
    RootView(injector: DependencyInjector(container: Container()))
}
