import SwiftUI
import Swinject

@main
struct OnlyCombineApp: App {

    private let injector: Injector
    
    init() {
        injector = DependencyInjector(container: Container())
        injector.assemble([
            SearchDomainAssembly(),
            SearchAssembly()
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(injector: injector)
        }
    }
}
