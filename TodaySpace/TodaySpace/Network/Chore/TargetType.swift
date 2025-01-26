//
//  TargetType.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = path
        components.queryItems = query
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return URLRequest(url: url)
    }
}
