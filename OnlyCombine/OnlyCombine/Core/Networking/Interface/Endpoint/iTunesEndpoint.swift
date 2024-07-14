import Foundation

public protocol iTunesEndpoint: EndpointType {
    var domain: iTunesAPIDomain { get }
    var errorMap: [Int: NetworkingError] { get }
}

public extension iTunesEndpoint {
    var baseURL: URL {
        let baseURL = "https://itunes.apple.com"
        return URL(
            string: "\(baseURL)/\(domain.rawValue)"
        ) ?? URL(string: "https://www.google.com")!
    }

    var validationCode: ClosedRange<Int> { 200...300 }

    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var timeout: TimeInterval { 60 }

    var errorMap: [Int: NetworkingError] { [:] }
}

private class BundleFinder {}

extension Foundation.Bundle {
    static let module = Bundle(for: BundleFinder.self)
}
