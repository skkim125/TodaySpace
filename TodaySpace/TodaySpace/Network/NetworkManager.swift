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
                throw NetworkError.checkNetworkError(errorCode: httpResponse.statusCode)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
                
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            throw NetworkError.invalidRequest
        }
    }
}
