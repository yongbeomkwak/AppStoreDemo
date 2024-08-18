import Foundation


public struct SearchNavigation: Hashable {
    let name: Name
}

extension SearchNavigation {
    public enum Name {
        case result
    }
}
