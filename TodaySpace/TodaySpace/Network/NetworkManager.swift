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

            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 419 {
                    do {
                        try await tokenRefresh()
                        return try await callRequest(targetType: targetType)
                    }
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorType.self, from: data)
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
        if let cachedImage = ImageCacher.shared.image(forKey: imageURL) {
            print("캐싱된 이미지")
            return cachedImage
        }
        
        guard let url = URL(string: API.baseURL + "/v1/" + imageURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(API.productId, forHTTPHeaderField: Header.productId)
        request.setValue(UserDefaultsManager.accessToken, forHTTPHeaderField: Header.authorization)
        request.setValue(API.apiKey, forHTTPHeaderField: Header.sesacKey)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.decodingError
        }
        
        ImageCacher.shared.insertImage(image, forKey: imageURL)
        return image
    }
    
    func tokenRefresh() async throws {
        do {
            let request = try AuthTarget.refresh.asURLRequest()
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 418 {
                    throw NetworkError.expiredRefreshToken
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorType.self, from: data)
                        throw errorResponse
                    } catch {
                        throw NetworkError.checkNetworkError(errorCode: httpResponse.statusCode)
                    }
                }
            }
            
            do {
                let decodedData = try JSONDecoder().decode(TokenResponse.self, from: data)
                UserDefaultsManager.refresh(decodedData.accessToken, decodedData.refreshToken)
                print("토큰 갱신 완료")
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
