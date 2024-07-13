import Foundation
import Combine

public struct JSONParameterEncoder: ParameterEncodable {
    public func encode(request: URLRequest, with parameter: [String : Any]) -> Future<URLRequest, CAlamofireError> {
        
        var request = request
        
        return Future<URLRequest, CAlamofireError> { promise in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: options)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                promise(.success(request))
                
                
            } catch {
                
                    promise(.failure(.encodingFailed))
            }
            
        }
    
    }
    
    public let options: JSONSerialization.WritingOptions

    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

    
}

public extension ParameterEncodable where Self == JSONParameterEncoder {
    static func json(options: JSONSerialization.WritingOptions = []) -> JSONParameterEncoder {
        JSONParameterEncoder(options: options)
    }
}
