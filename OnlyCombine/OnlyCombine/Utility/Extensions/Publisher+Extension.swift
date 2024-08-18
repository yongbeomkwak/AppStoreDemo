import Foundation
import Combine

extension Publisher  {
    func withUnretained<T: AnyObject>(_ obj: T) -> AnyPublisher<(T, Self.Output), Failure> {
        self
            .compactMap { [weak obj] output -> (T, Self.Output)? in
                guard let obj = obj else { return nil }
                return (obj, output)
            }
            .eraseToAnyPublisher()
    }
}
