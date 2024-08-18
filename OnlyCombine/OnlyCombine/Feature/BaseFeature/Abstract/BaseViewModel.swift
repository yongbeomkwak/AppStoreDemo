import Foundation
import Combine


open class BaseViewModel: ObservableObject {
    
    public var subscription = Set<AnyCancellable>()
    @Published var isLoading:Bool = true
    
    
    open func bind() { fatalError("Must Override") }
    
}
