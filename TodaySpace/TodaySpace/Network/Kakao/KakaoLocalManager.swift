//
//  KakaoLocalManager.swift
//  TodaySpace
//
//  Created by 김상규 on 1/30/25.
//

import Foundation

final class KakaoLocalManager {
    static let shared = KakaoLocalManager()
    private init() { }
    
    private let networkManager = NetworkManager.shared
    
    func searchPlace(query: String) async throws -> [PlaceInfo] {
        let searchQuery = KakaoLocalQuery(query: query)
        print(searchQuery)
        do {
            return try await networkManager.callRequest(targetType: KakaoTarget.search(searchQuery))
        } catch {
            print(error)
            throw error
        }
    }
}
