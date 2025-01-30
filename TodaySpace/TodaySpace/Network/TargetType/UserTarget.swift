//
//  UserTarget.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum UserTarget {
    case emailLogin(EmailLoginBody)
}

extension UserTarget: TargetType {
    var baseURL: String {
        return API.baseURL + "/v1"
    }
    
    var header: [String : String] {
        switch self {
        case .emailLogin:
            return [
                Header.contentType: ContentType.json,
                Header.productId: API.productId,
                Header.authorization: UserDefaultsManager.accessToken,
                Header.sesacKey: API.apiKey,
            ]
        }
    }
    
    var path: String? {
        switch self {
        case .emailLogin:
            return "users/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .emailLogin:
            return .post
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .emailLogin:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .emailLogin(let body):
            do {
                let data = try encoder.encode(body)
                return data
            } catch {
                print("인코딩 실패: \(error)")
                return nil
            }
        }
    }
}
