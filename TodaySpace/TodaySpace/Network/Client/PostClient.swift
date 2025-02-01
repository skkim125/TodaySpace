//
//  PostClient.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation
import ComposableArchitecture

struct PostClient {
    var uploadImage: (ImageUploadBody) async throws -> ImageUploadResponse
    var postUpload: (PostBody) async throws -> PostResponse
}

extension PostClient: DependencyKey {
    
    static let liveValue = PostClient(
        uploadImage: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.uploadImage(body))
            } catch let error as NetworkError {
                throw error
            }
        },
        
        postUpload: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.postUpload(body))
            } catch let error as NetworkError {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var postClient: PostClient {
        get { self[PostClient.self] }
        set { self[PostClient.self] = newValue }
    }
}
