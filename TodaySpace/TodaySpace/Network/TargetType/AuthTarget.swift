//
//  AuthTarget.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum AuthTarget {
    case refresh
}

extension AuthTarget: TargetType {
    var baseURL: String {
        return API.baseURL
    }
    
    var header: [String : String] {
        return [
            Header.contentType: ContentType.json,
            Header.productId: API.productId,
            Header.refreshToken: UserDefaultsManager.refreshToken,
            Header.authorization: UserDefaultsManager.accessToken,
            Header.sesacKey: API.apiKey
        ]
    }
    
    var path: String {
        return "auth/refresh"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
}
