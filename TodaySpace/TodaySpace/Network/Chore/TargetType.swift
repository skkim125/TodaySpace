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
        
        request.allHTTPHeaderFields = header
        request.httpMethod = method.rawValue
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
