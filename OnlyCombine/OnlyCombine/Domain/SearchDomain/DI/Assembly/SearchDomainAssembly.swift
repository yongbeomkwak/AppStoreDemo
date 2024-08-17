import Foundation
import Swinject

struct SearchDomainAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(RemoteSearchDataSource.self) { _ in
            return RemoteSearchDataSourceImpl()
        }
        
        container.register(SearchRepository.self) { r in
            
            let dataSource = container.resolve(RemoteSearchDataSource.self)!
            
            return SearchRepositoryImpl(remoteSearchDataSource: dataSource)
        }
        
        container.register(FetchSearchResultUseCase.self) { r in
            let repository = container.resolve(SearchRepository.self)!
            
            return FetchSearchResultUseCaseImpl(searchRepository: repository)
        }
        
    }
    
}
