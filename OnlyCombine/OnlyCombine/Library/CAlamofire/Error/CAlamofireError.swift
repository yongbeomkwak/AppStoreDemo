import Foundation

public enum CAlamofireError: Error {
    case encodingFailed
    case networkError
    case notFoundOwner
    case missingURL
    case statusCode(DataResponse)
    case underlying(Swift.Error)
}

extension CAlamofireError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "failed to encoding parameters"

        case .networkError:
            return "failed to request"

        case .notFoundOwner:
            return "this error occured arc"

        case .missingURL:
            return "URL is missing"

        case .statusCode:
            return "status code didn't fall within the given range."

        case let .underlying(error):
            return error.localizedDescription
        }
    }
}

extension CAlamofireError {
    public var underlyingError: Swift.Error? {
        switch self {
        case let .underlying(error):
            return error

        default:
            return nil
        }
    }
}

extension CAlamofireError {
    public var response: DataResponse? {
        switch self {
        case let .statusCode(response):
            return response

        default:
            return nil
        }
    }
}

extension CAlamofireError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }
}
