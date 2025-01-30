//
//  PostTarget.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum PostTarget {
    case posting
}

extension PostTarget: TargetType {
    var baseURL: String {
        return API.baseURL + "/v1"
    }
    
    var header: [String : String] {
        return [
            Header.contentType: ContentType.json,
            Header.productId: API.productId,
            Header.authorization: UserDefaultsManager.accessToken,
            Header.sesacKey: API.apiKey,
        ]
    }
    
    var path: String? {
        return nil
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
