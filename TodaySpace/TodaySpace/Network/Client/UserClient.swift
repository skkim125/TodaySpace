//
//  UserClient.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import Foundation
import ComposableArchitecture

struct UserClient {
    var emailLogin: (EmailLoginBody) async throws -> EmailLoginResponse
}

extension UserClient: DependencyKey {
    
    static let liveValue = UserClient(
        emailLogin: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: UserTarget.emailLogin(body))
            } catch let error as NetworkError {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
