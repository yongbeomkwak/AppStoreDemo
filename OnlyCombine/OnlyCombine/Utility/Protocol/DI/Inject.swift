import Foundation
import Swinject

/// DI 대상 등록
public protocol DependencyAssemblable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: T)
}

/// DI 등록한 서비스 사용
public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
    
    // 한 개의 인수를 처리하는 resolve 함수
    func resolve<T, Arg1>(_ serviceType: T.Type, argument: Arg1) -> T

    // 두 개의 인수를 처리하는 resolve 함수
    func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, arguments arg1: Arg1, _ arg2: Arg2) -> T
    
    // 세 개의 인수를 처리하는 resolve 함수
    func resolve<T, Arg1, Arg2, Arg3>(_ serviceType: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T
    
    // 네 개의 인수를 처리하는 resolve 함수
    func resolve<T, Arg1, Arg2, Arg3, Arg4>(_ serviceType: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> T
}

public typealias Injector = DependencyAssemblable & DependencyResolvable
