//
//  NetworkError.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum NetworkError: Int, Error, LocalizedError {
    case invalidValue = 400
    case invalidToken = 401
    case forbidden = 403
    case expiredRefreshToken = 418
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
    
    var errorDescription: String {
        let retry = "잠시 후 다시 시도해주세요."
        
        switch self {
        case .invalidValue:
            return "필수값을 입력해주세요"
        case .invalidToken:
            return "로그인을 진행할 수 없습니다."
        case .forbidden:
            return "서비스를 이용할 수 없습니다."
        case .expiredRefreshToken:
            return "로그인 세션이 만료되었습니다.\n 로그인 화면으로 이동합니다."
        case .expiredAccessToken:
            return "액세스 토큰이 만료되었습니다."
        case .invalidKey:
            return "인증할 수 없는 키입니다."
        case .invalidProductId:
            return "인증할 수 없는 ProductId"
        case .overcall:
            return "검색 횟수를 초과하였습니다."
        case .invalidURL:
            return "잘못된 URL 입니다."
        case .serverError:
            return "서버에 연결할 수 없습니다."
        case .invalidRequest:
            return "조회를 할 수 없습니다."
        case .invalidResponse:
            return "Response를 받아올 수 없습니다."
        case .decodingError:
            return "디코딩에 실패하였습니다."
        case .unknownError:
            return "알 수 없는 에러입니다."
        }
    }
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
