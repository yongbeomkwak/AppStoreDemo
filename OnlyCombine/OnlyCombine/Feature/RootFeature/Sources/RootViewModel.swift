import Foundation
import Combine

final class RootViewModel: BaseViewModel {
    
    
    override init() {
        super.init()
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.isLoading = false
        }
    }
    
    override func bind() {
        print("Hello")
    }
}

