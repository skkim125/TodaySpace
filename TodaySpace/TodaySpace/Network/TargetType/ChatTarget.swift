//
//  ChatTarget.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum ChatTarget {
    
}

extension ChatTarget: TargetType {
    var baseURL: String {
        return API.baseURL
    }
    
    var header: [String : String] {
        return [
            Header.contentType: ContentType.json,
            Header.productId: API.productId,
            Header.authorization: UserDefaultsManager.accessToken,
            Header.sesacKey: API.apiKey,
        ]
    }
    
    var path: String {
        return ""
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
