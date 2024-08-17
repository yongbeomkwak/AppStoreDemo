import Foundation
import Combine

open class BaseViewModel {
    
    var subscription: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    
}
