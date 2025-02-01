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
            print(httpResponse)

            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 401 || httpResponse.statusCode == 419 {
                    do {
                        try await tokenRefresh()
                        return try await callRequest(targetType: targetType)
                    }
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorType.self, from: data)
                        print(errorResponse.message)
                        throw errorResponse
                    } catch {
                        throw NetworkError.checkNetworkError(errorCode: httpResponse.statusCode)
                    }
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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorType.self, from: data)
                    throw errorResponse
                } catch {
                    throw NetworkError.checkNetworkError(errorCode: httpResponse.statusCode)
                }
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
