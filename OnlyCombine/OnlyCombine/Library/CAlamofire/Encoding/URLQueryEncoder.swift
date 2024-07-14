import Foundation

/// Credits By https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift
public struct URLQueryEncoder: ParameterEncodable {
    public enum ArrayEncoding {
        
    /// brackets: 키 뒤에 빈 대괄호를 추가합니다. 예)  items[]
    /// noBrackets: 키를 그대로 반환합니다. 예) items
    /// indexInBrackets: 키 뒤에 인덱스를 포함한 대괄호를 추가합니다. 예) items[1]
    /// custom: 클로저를 사용하여 키를 인코딩합니다. 예) items-1
        
        case brackets
      
        case noBrackets
  
        case indexInBrackets

        case custom((_ key: String, _ index: Int) -> String)

        func encode(key: String, atIndex index: Int) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            case .indexInBrackets:
                return "\(key)[\(index)]"
            case let .custom(encoding):
                return encoding(key, index)
            }
        }
    }

    public enum BoolEncoding {
        /// Encode `true` as `1` and `false` as `0`. This is the default behavior.
        case numeric
        /// Encode `true` and `false` as string literals.
        case literal

        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }

    public let arrayEncoding: ArrayEncoding
    public let boolEncoding: BoolEncoding

    public init(arrayEncoding: ArrayEncoding = .noBrackets, boolEncoding: BoolEncoding = .literal) {
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }

    public func encode(request: inout URLRequest, with parameter: [String: Any]) throws {
        guard let url = request.url else { throw CAlamofireError.missingURL }

        ///        resolvingAgainstBaseURL 옵션은 주어진 URL을 해석할 때 기본 베이스 URL을 기준으로 상대 경로를 해석할지 여부를 결정합니다.
        ///        이 옵션은 상대 경로를 포함하는 URL을 처리할 때 유용합니다.
        ///       옵션 설명
        ///       true: 주어진 URL이 상대 경로일 경우, 이를 베이스 URL에 대해 해석합니다.
        ///       false: 주어진 URL을 독립적으로 해석합니다. 즉, 베이스 URL을 사용하지 않고 주어진 URL 자체만을 해석합니다.
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameter.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameter)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            request.url = urlComponents.url
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}

private extension URLQueryEncoder {
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        
        var components: [(String, String)] = []
        switch value {
        case let dictionary as [String: Any]: // value가 딕셔너리 key/nestedKey/value
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }

        case let array as [Any]: // value가 array
            for (index, value) in array.enumerated() {
                components += queryComponents(fromKey: arrayEncoding.encode(key: key, atIndex: index), value: value)
            }

        case let number as NSNumber:
            if number.isBool {
                components.append((escape(key), escape(boolEncoding.encode(value: number.boolValue))))
            } else {
                components.append((escape(key), escape("\(number)")))
            }

        case let bool as Bool:
            components.append((escape(key), escape(boolEncoding.encode(value: bool))))

        default:
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }

    func escape(_ string: String) -> String {
///        addingPercentEncoding 함수는 Swift 언어에서 문자열을 URL 인코딩하는 데 사용됩니다.
///        이 함수는 URL에 사용될 수 없는 문자를 퍼센트 인코딩하여 URL에서 유효한 형식으로 만들어줍니다. 퍼센트 인코딩은 특수 문자를 % 기호와 해당 문자의 ASCII 값으로 대체하는 방법입니다.
///        예를 들어, URL에 포함될 수 없는 공백 문자는 %20으로 인코딩됩니다.
        string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }

    func query(_ parameters: [String: Any]) -> String {
        // 들어온 파라미터들을 query형태로 바꿔서 리턴 
        return parameters
            .reduce(into: [(String, String)]()) { partialResult, dict in
                let queryComponents = queryComponents(fromKey: dict.key, value: dict.value)
                partialResult.append(contentsOf: queryComponents)
            }
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
    }
}

fileprivate extension NSNumber {
    var isBool: Bool {
        // Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
        // swift-corelibs-foundation, per [this discussion on the Swift forums](https://forums.swift.org/t/alamofire-on-linux-possible-but-not-release-ready/34553/22).
        String(cString: objCType) == "c"
    }
}

public extension ParameterEncodable where Self == URLQueryEncoder {
    static func urlQuery(
        arrayEncoding: URLQueryEncoder.ArrayEncoding = .noBrackets,
        boolEncoding: URLQueryEncoder.BoolEncoding = .literal
    ) -> URLQueryEncoder {
        URLQueryEncoder(arrayEncoding: arrayEncoding, boolEncoding: boolEncoding)
    }
}
