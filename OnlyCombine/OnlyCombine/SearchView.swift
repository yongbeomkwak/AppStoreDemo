import SwiftUI
import Combine

class ViewModel {
    
    var subscription = Set<AnyCancellable>()
    
    let nt = CombineNetworkingImpl(client: .init() )
    let dataSource = RemoteSearchDataSourceImpl()
    lazy var  repository = SearchRepositoryImpl(remoteSearchDataSource: dataSource)
    lazy var usecase = FetchSearchResultUseCaseImpl(searchRepository: repository)
    
    init() {
        usecase.execute(text: "AF", limit: 20)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("FIN")
                }
                
            }, receiveValue: { entity in
                print(entity)
            })
            .store(in: &subscription)
    }
     
    
}

struct SearchView: View {
    
    var viewModel = ViewModel()
   
    
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
    SearchView()
}
