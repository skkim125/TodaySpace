//
//  PostDetailFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct PostDetailFeature: Reducer {
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.postClient) var postClient
    
    @ObservableState
    struct State {
        var post: PostResponse
        var comments: [Comment] {
            post.comments.sorted(by: { $0.createdAt ?? "" < $1.createdAt ?? ""})
        }
        var commentText: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case commentButtonTap
        case commentSuccess(Comment)
        case fetchCurrentPostSuccess(PostResponse)
        case dismiss
        case dismissAction(PostResponse)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .commentButtonTap:
                if !state.commentText.isEmpty {
                    let postID = state.post.post_id
                    let body = CommentBody(content: state.commentText)
                    
                    return .run { send in
                        do {
                            let result = try await postClient.comments(postID, body)
                            await send(.commentSuccess(result))
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    return .none
                }
            case .commentSuccess(let comments):
                print(comments)
                
                let postID = state.post.post_id
                state.commentText = ""
                return .run { send in
                    do {
                        let result = try await postClient.fetchCurrentPost(postID)
                        await send(.fetchCurrentPostSuccess(result))
                    } catch {
                        print(error)
                    }
                }
                
            case .fetchCurrentPostSuccess(let post):
                state.post = post
                
                return .none
                
            case .dismiss:
                let postID = state.post.post_id
                return .run { send in
                    do {
                        let result = try await postClient.fetchCurrentPost(postID)
                        await send(.dismissAction(result))
                        await self.dismiss()
                    } catch {
                        print(error)
                    }
                }
                
            case .dismissAction:
                return .none
            }
        }
    }
}
