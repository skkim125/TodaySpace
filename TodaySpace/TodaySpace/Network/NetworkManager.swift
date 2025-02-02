//
//  NetworkManager.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import SwiftUI

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
    
    
    func fetchImage(imageURL: String) async throws -> UIImage {
        guard let url = URL(string: API.baseURL + "/v1/" + imageURL) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        print(url)
        
        request.setValue(API.productId, forHTTPHeaderField: Header.productId)
        request.setValue(UserDefaultsManager.accessToken, forHTTPHeaderField: Header.authorization)
        request.setValue(API.apiKey, forHTTPHeaderField: Header.sesacKey)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 401 || httpResponse.statusCode == 419 {
                    do {
                        try await tokenRefresh()
                        return try await fetchImage(imageURL: imageURL)
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
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingError
            }
            
            return image
        } catch {
            print("이미지 로드 실패")
            
            throw error
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
            print("토큰 갱신 실패: \(error)")
            throw error
        }
    }
}
