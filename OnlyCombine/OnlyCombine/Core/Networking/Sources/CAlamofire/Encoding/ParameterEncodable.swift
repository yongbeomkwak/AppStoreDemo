import Foundation
import Combine

public protocol ParameterEncodable {
    func encode(request: URLRequest, with parameter: [String: Any]) -> Future<URLRequest, CAlamofireError>
}
