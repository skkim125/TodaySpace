//
//  NetworkManager.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(targetType: TargetType) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: targetType.asURLRequest())
            
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }

            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 401 || httpResponse.statusCode == 419 {
                    do {
                        try await tokenRefresh()
                        return try await callRequest(targetType: targetType)
                    }
                }
                do {
                    // 서버에서 온 에러 메시지를 ErrorType으로 디코딩
                    let errorResponse = try JSONDecoder().decode(ErrorType.self, from: data)
                    throw errorResponse
                } catch {
                    // 에러 메시지 파싱에 실패한 경우 기본 네트워크 에러로 폴백
                    throw NetworkError.checkNetworkError(errorCode: httpResponse.statusCode)
                }
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
                
            } catch {
                throw NetworkError.decodingError
            }
        }
    }
    
    func tokenRefresh() async throws {
        do {
            let request = try AuthTarget.refresh.asURLRequest()
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let decodedData = try JSONDecoder().decode(TokenResponse.self, from: data)
                UserDefaultsManager.refresh(decodedData.accessToken, decodedData.refreshToken)
                return 
            } catch {
                print("Decoding Error: \(error)")
                throw NetworkError.decodingError
            }
            
        } catch {
            print("🚨 토큰 갱신 요청 실패: \(error)")
            throw error
        }
    }
}
