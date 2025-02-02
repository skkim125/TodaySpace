//
//  TargetType.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        guard let baseURL = URL(string: baseURL) else { throw NetworkError.invalidURL }
        var components = URLComponents(
            url: baseURL.appending(path: path ?? ""),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = query
        
        guard let url = components?.url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        
        request.timeoutInterval = 5
        request.allHTTPHeaderFields = header
        request.httpMethod = method.rawValue
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}

extension TargetType {
    func convertMultipartFormData(boundary: String, datas: [Data], filename: String) -> Data {
        let crlf = "\r\n"
        let data = NSMutableData()
        
        datas.forEach {
            data.append("--\(boundary)\(crlf)".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(filename)\"\(crlf)".data(using: .utf8)!)
            data.append("Content-Type: image/png\(crlf)\(crlf)".data(using: .utf8)!)
            data.append($0)
            data.append("\(crlf)".data(using: .utf8)!)
        }
        data.append("--\(boundary)--\(crlf)".data(using: .utf8)!)
        
        return data as Data
    }
}
