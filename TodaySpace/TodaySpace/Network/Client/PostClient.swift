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
    var fetchPost: (FetchPostQuery) async throws -> FetchPostResponse
    var fetchAreaPost: (FetchAreaPostQuery) async throws -> FetchAreaPostResponse
    var comments: (String, CommentBody) async throws -> Comment
    var fetchCurrentPost: (String) async throws -> PostResponse
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
        },
        
        fetchPost: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.fetchPost(body))
            } catch let error as NetworkError {
                throw error
            }
        },
        
        fetchAreaPost: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.fetchAreaPost(body))
            } catch let error as NetworkError {
                throw error
            }
        },
        
        comments: { postID, body  in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.comment(postID, body))
            } catch let error as NetworkError {
                throw error
            }
        },
        
        fetchCurrentPost: { postID in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.fetchCurrentPost(postID))
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
