//
//  KakaoLocalTarget.swift
//  TodaySpace
//
//  Created by 김상규 on 3/1/25.
//

import Foundation

enum KakaoLocalTarget {
    case search(KakaoLocalQuery)
}

extension KakaoLocalTarget: TargetType {
    var baseURL: String {
        return API.kakaoLocalURL + "/v2"
    }
    
    var header: [String : String] {
        return [
            Header.authorization: "\(Header.key) \(API.kakaoRestApiKey)",
            Header.contentType: ContentType.json
        ]
    }
    
    var path: String? {
        return "local/search/keyword"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .search(let query):
            [
                URLQueryItem(name: SearchHeader.sort.rawValue, value: query.sort),
                URLQueryItem(name: SearchHeader.size.rawValue, value: "\(query.size)"),
                URLQueryItem(name: SearchHeader.page.rawValue, value: "\(query.page)"),
                URLQueryItem(name: SearchHeader.query.rawValue, value: query.query),
            ]
        }
    }
    
    var body: Data? {
        return nil
    }
    
    private enum SearchHeader: String {
        case sort
        case size
        case page
        case query
    }
}
