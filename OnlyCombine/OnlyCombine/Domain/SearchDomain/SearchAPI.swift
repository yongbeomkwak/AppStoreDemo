import Foundation

enum SearchAPI {
    case fetchSearchItem(text: String, limit: Int)
}

extension SearchAPI: iTunesEndpoint {
    var domain: iTunesAPIDomain {
        .search
    }

    var route: Route {
        switch self {
        case .fetchSearchItem:
                .get("")
        }
    }

    var task: HTTPTask {
        switch self {
        
        case let .fetchSearchItem(text: text, limit: limit):
                .requestParameters(query:[
                    "term": text,
                    "limit":limit,
                    "country":"KR",
                    "media": "software"
                ])
        }
    }



    var errorMap: [Int: NetworkingError ] {
        switch self {

        default:
            return [
                400: .badRequest,
                404: .notFound,
                409: .conflict,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }

    var validationCode: ClosedRange<Int> {
        switch self {

        default:
            return 200...300
        }
    }
}
