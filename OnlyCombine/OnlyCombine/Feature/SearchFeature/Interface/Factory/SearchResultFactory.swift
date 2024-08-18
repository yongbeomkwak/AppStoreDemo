import SwiftUI

public protocol SearchResultFactory {
    
    associatedtype ViewType: View
    
    func makeView(text: String) -> ViewType
    
}
