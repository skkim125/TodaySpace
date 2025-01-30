//
//  API.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum API {
    static let baseURL = Bundle.main.object(
        forInfoDictionaryKey: "API_URL"
    ) as? String ?? ""
    
    static let kakaoLocalURL = Bundle.main.object(
        forInfoDictionaryKey: "KAKAO_LOCAL_URL"
    ) as? String ?? ""
    
    static let apiKey = Bundle.main.object(
        forInfoDictionaryKey: "API_KEY"
    ) as? String ?? ""
    
    static let kakaoRestApiKey = Bundle.main.object(
        forInfoDictionaryKey: "KAKAO_REST_API_KEY"
    ) as? String ?? ""
    
    static let productId = Bundle.main.object(
        forInfoDictionaryKey: "PRODUCT_ID"
    ) as? String ?? ""
}

enum Header {
    static let authorization = "Authorization"
    static let productId = "ProductId"
    static let sesacKey = "SesacKey"
    static let refreshToken = "RefreshToken"
    static let contentType = "Content-Type"
    static let key = "KakaoAK"
}

enum ContentType {
    static let json = "application/json"
    static let multpartform = "multipart/form-data"
}
