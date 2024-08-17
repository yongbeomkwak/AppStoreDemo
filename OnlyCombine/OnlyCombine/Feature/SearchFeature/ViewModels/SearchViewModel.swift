import Foundation
import Combine

final class SearchViewModel {
    
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
