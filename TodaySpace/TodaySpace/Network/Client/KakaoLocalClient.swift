//
//  KakaoLocalClient.swift
//  TodaySpace
//
//  Created by 김상규 on 3/1/25.
//

import ComposableArchitecture

struct KakaoLocalClient {
    var searchPlace: (String) async throws -> PlaceResponse
}

extension KakaoLocalClient: DependencyKey {
    static let liveValue = KakaoLocalClient(
        searchPlace: { query in
            let searchQuery = KakaoLocalQuery(query: query)
            do {
                return try await NetworkManager.shared.callRequest(targetType: KakaoLocalTarget.search(searchQuery))
            } catch {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var kakaoLocalClient: KakaoLocalClient {
        get { self[KakaoLocalClient.self] }
        set { self[KakaoLocalClient.self] = newValue }
    }
}
