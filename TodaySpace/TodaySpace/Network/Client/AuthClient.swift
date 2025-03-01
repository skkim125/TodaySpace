//
//  AuthClient.swift
//  TodaySpace
//
//  Created by 김상규 on 1/28/25.
//

import Foundation
import ComposableArchitecture

struct AuthClient {
    var tokenRefresh: () async throws -> TokenResponse
}

extension AuthClient: DependencyKey {
    
    static let liveValue = AuthClient(
        tokenRefresh: {
            do {
                return try await NetworkManager.shared.callRequest(targetType: AuthTarget.refresh)
            } catch {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
