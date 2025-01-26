//
//  NetworkError.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum NetworkError: Int, Error {
    case invalidValue = 400
    case invalidToken = 401
    case forbidden = 403
    case expiredAccessToken = 419
    case invalidKey = 420
    case invalidProductId = 421
    case overcall = 429
    case invalidURL = 444
    case serverError = 500
    
    case invalidRequest
    case invalidResponse
    case decodingError
    case unknownError
}

extension NetworkError {
    static func checkNetworkError(errorCode: Int) -> NetworkError {
        switch errorCode {
        case 400:
            return .invalidValue
        case 401:
            return .invalidToken
        case 403:
            return .forbidden
        case 419:
            return .expiredAccessToken
        case 420:
            return .invalidKey
        case 421:
            return .invalidProductId
        case 429:
            return .overcall
        case 444:
            return .invalidURL
        case 500:
            return .serverError
        default:
            return .unknownError
        }
    }
}
