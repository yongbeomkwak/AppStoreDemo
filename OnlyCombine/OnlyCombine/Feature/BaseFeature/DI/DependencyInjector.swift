import Foundation
import Swinject

final class DependencyInjector: Injector {
    
    let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func assemble(_ assemblyList: [any Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
    
    public func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { _ in object }
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
    
    // 한 개의 인수를 처리하는 resolve 함수
    public func resolve<T, Arg1>(_ serviceType: T.Type, argument: Arg1) -> T {
        container.resolve(serviceType, argument: argument)!
    }

    // 두 개의 인수를 처리하는 resolve 함수
    public func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        container.resolve(serviceType, arguments: arg1, arg2)!
    }
    
    // 세 개의 인수를 처리하는 resolve 함수
    public func resolve<T, Arg1, Arg2, Arg3>(_ serviceType: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T {
        container.resolve(serviceType, arguments: arg1, arg2, arg3)!
    }
    
    // 네 개의 인수를 처리하는 resolve 함수
    public func resolve<T, Arg1, Arg2, Arg3, Arg4>(_ serviceType: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> T {
        container.resolve(serviceType, arguments: arg1, arg2, arg3, arg4)!
    }
    
}
