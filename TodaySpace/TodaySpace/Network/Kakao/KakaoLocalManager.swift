//
//  KakaoLocalManager.swift
//  TodaySpace
//
//  Created by 김상규 on 1/30/25.
//

import Foundation

final class KakaoLocalManager: ObservableObject {
    static let shared = KakaoLocalManager()
    private init() { }

    private let networkManager = NetworkManager.shared
    @Published var results: [PlaceInfo] = []
    
    func searchPlace(query: String) async throws {
        let searchQuery = KakaoLocalQuery(query: query)
        
        do {
            let data: PlaceResponse = try await networkManager.callRequest(targetType: KakaoTarget.search(searchQuery))
            await MainActor.run {
                results = data.results
            }
        } catch {
            throw error
        }
    }
}
