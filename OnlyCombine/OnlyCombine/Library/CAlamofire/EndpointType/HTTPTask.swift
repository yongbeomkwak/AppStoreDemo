import Foundation

public enum HTTPTask {
    case requestPlain
    case requestParameters(
        body: [String: Any]? = nil,
        bodyEncoder: any ParameterEncodable = .json(),
        query: [String: Any]? = nil,
        queryEncoder: any ParameterEncodable = .urlQuery()
    )
    case requestJSONEncodable(
        _ encodable: any Encodable,
        jsonEncoder: JSONEncoder = .init(),
        query: [String: Any]? = nil,
        queryEncoder: any ParameterEncodable = .urlQuery()
    )
//    case uploadMultipart([MultiPartFormData])
}

public extension HTTPTask {
    func configureRequest(request: inout URLRequest) throws {
        switch self {
        case .requestPlain:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        case let .requestParameters(body, bodyEncoder, query, queryEncoder):
            try configureParams(body: body, bodyEncoder: bodyEncoder, query: query, queryEncoder: queryEncoder, request: &request)

        case let .requestJSONEncodable(encodable, jsonEncoder, query, queryEncoder):
            try configureEncodable(
                encodable: encodable,
                jsonEncoder: jsonEncoder,
                query: query,
                queryEncoder: queryEncoder,
                request: &request
            )

//        case let .uploadMultipart(multiParts):
//            try configureMultiparts(formDatas: multiParts, request: &request)
        }
    }

    func configureParams(
        body: [String: Any]?,
        bodyEncoder: any ParameterEncodable,
        query: [String: Any]?,
        queryEncoder: any ParameterEncodable,
        request: inout URLRequest
    ) throws {
        if let body {
            try bodyEncoder.encode(request: &request, with: body)
        }
        if let query {
            try queryEncoder.encode(request: &request, with: query)
        }
    }

    func configureEncodable(
        encodable: any Encodable,
        jsonEncoder: JSONEncoder,
        query: [String: Any]?,
        queryEncoder: any ParameterEncodable,
        request: inout URLRequest
    ) throws {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try jsonEncoder.encode(encodable)

        if let query {
            try queryEncoder.encode(request: &request, with: query)
        }
    }

//    func configureMultiparts(
//        formDatas: [MultiPartFormData],
//        request: inout URLRequest
//    ) throws {
//        let boundary = String(
//            format: "request.boundary.%08x%08x",
//            UInt32.random(in: .min ... .max),
//            UInt32.random(in: .min ... .max)
//        )
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        let bodyData = buildFormBodyData(formDatas: formDatas, boundary: boundary)
//        request.httpBody = bodyData
//    }
//
//    func buildFormBodyData(
//        formDatas: [MultiPartFormData],
//        boundary: String
//    ) -> Data {
//        var formBody = Data()
//        let boundaryPrefix = "--\(boundary)\r\n"
//        for formData in formDatas {
//            formBody.append(boundaryPrefix.data(using: .utf8) ?? .init())
//            if let filename = formData.fileName, !filename.isEmpty {
//                formBody.append("Content-Disposition: form-data; name=\"\(formData.field)\"; filename=\"\(filename)\"\r\n".data(using: .utf8) ?? .init())
//                formBody.append(
//                    "Content-Type: image/\(filename.components(separatedBy: ".").last ?? "png")\r\n\r\n"
//                        .data(using: .utf8) ?? .init()
//                )
//            } else {
//                formBody.append("Content-Disposition: form-data; name=\"\(formData.field)\"\r\n\r\n".data(using: .utf8) ?? .init())
//            }
//            formBody.append(formData.data)
//            formBody.append("\r\n".data(using: .utf8) ?? .init())
//        }
//        formBody.append("--\(boundary)--".data(using: .utf8) ?? .init())
//        return formBody
//    }
}
