import Foundation

public struct JSONParameterEncoder: ParameterEncodable {
    public let options: JSONSerialization.WritingOptions
    ///    JSONSerialization.WritingOptions는 Swift에서 JSON 데이터를 작성할 때 사용할 수 있는 옵션을 정의하는 열거형입니다.
    ///    이 옵션을 사용하면 JSON 데이터를 특정 형식으로 출력할 수 있습니다. 이 열거형은 JSONSerialization 클래스의 data(withJSONObject:options:) 메서드와 함께 사용됩니다.
    ///    주요 옵션으로는 prettyPrinted, sortedKeys, fragmentsAllowed, withoutEscapingSlashes
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

    public func encode(request: inout URLRequest, with parameter: [String: Any]) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: options)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            throw CAlamofireError.encodingFailed
        }
    }
}

public extension ParameterEncodable where Self == JSONParameterEncoder {
    static func json(options: JSONSerialization.WritingOptions = []) -> JSONParameterEncoder {
        JSONParameterEncoder(options: options)
    }
}

/*
    case prettyPrinted = 1
    JSON 데이터를 보기 좋게 들여쓰기와 줄바꿈을 사용하여 출력합니다. 이 옵션을 사용하면 사람이 읽기 쉽게 포맷된 JSON 문자열을 생성할 수 있습니다.

    {
    "name": "John",
    "age": 30,
    "isDeveloper": true
    }
*/


/*
    case sortedKeys = 2
    JSON 객체의 키를 사전순으로 정렬합니다. 이는 가독성을 높이고, 디버깅이나 버전 관리를 용이하게 할 수 있습니다.

    json
    {
        "age": 30,
        "isDeveloper": true,
        "name": "John"
    }
*/


/*
    case fragmentsAllowed = 4
    JSON 규격에 맞지 않는 단일 값이나 프래그먼트를 허용합니다. 일반적으로 JSON 객체나 배열이 아닌 단일 문자열, 숫자, 불리언 등의 값을 JSON으로 변환할 때 사용됩니다.

    json
    "A single JSON fragment"
*/

/*
    case withoutEscapingSlashes = 8
    슬래시 문자를 이스케이프하지 않고 그대로 출력합니다. 기본적으로 JSON에서 슬래시는 \/로 이스케이프되지만, 이 옵션을 사용하면 원래 슬래시 /가 유지됩니다.
*/
