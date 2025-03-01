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
    var starToggle: (String, StarStatusBody) async throws -> StarStatusResponse
    var deletePost: (String) async throws -> EmptyResponse
}

extension PostClient: DependencyKey {
    
    static let liveValue = PostClient(
        uploadImage: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.uploadImage(body))
            } catch {
                throw error
            }
        },
        
        postUpload: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.postUpload(body))
            } catch {
                throw error
            }
        },
        
        fetchPost: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.fetchPost(body))
            } catch {
                throw error
            }
        },
        
        fetchAreaPost: { body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.fetchAreaPost(body))
            } catch {
                throw error
            }
        },
        
        comments: { postID, body  in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.comment(postID, body))
            } catch {
                throw error
            }
        },
        
        fetchCurrentPost: { postID in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.fetchCurrentPost(postID))
            } catch {
                throw error
            }
        },
        
        starToggle: { postID, body in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.starToggle(postID, body))
            } catch {
                throw error
            }
        },
        
        deletePost: { postID in
            do {
                return try await NetworkManager.shared.callRequest(targetType: PostTarget.deletePost(postID))
            } catch {
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
