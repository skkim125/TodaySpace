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
        var postID: String
        var postCreatorID: String = ""
        var title: String = ""
        var content: String = ""
        var placeName: String = ""
        var placeAddress: String = ""
        var createdAt: String = ""
        var placeLink: String = ""
        var visitedDate: String = ""
        var isLiked: Bool = false
        var likeCount: Int = 0
        var postCreatorName: String = ""
        var postCreatorProfile: String = ""
        var comments: [Comment] = []
        var commentText: String = ""
        var images: [String] = []
        var lat: Double = 0.0
        var lon: Double = 0.0
        var isLoading: Bool = false
        var categoryImage: String = ""
        var showPlaceLocationSheet: Bool = false
        var showPlaceWebView: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case viewAppear
        case commentButtonTap
        case commentSuccess(Comment)
        case fetchCurrentPostSuccess(PostResponse)
        case fetchError(Error)
        case dismiss
        case dismissAction(PostResponse)
        case toggleLiked
        case showPlaceWebView
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .viewAppear:
                state.isLoading = true
                return .run { [postID = state.postID] send in
                    do {
                        let post = try await postClient.fetchCurrentPost(postID)
                        await send(.fetchCurrentPostSuccess(post))
                    } catch {
                        await send(.fetchError(error))
                    }
                }
                
            case .commentButtonTap:
                if !state.commentText.isEmpty {
                    state.isLoading = true
                    let postID = state.postID
                    let body = CommentBody(content: state.commentText)
                    
                    return .run { send in
                        do {
                            let result = try await postClient.comments(postID, body)
                            await send(.commentSuccess(result))
                        } catch {
                            await send(.fetchError(error))
                        }
                    }
                }
                
                return .none
            case .commentSuccess:
                let postID = state.postID
                state.commentText = ""
                return .run { send in
                    do {
                        let result = try await postClient.fetchCurrentPost(postID)
                        await send(.fetchCurrentPostSuccess(result))
                    } catch {
                        await send(.fetchError(error))
                    }
                }
                
            case .fetchCurrentPostSuccess(let post):
                state.postCreatorID = post.creator.user_id ?? ""
                print(state.postCreatorID)
                state.title = post.title
                state.content = post.content
                state.createdAt = post.createdAt
                state.likeCount = post.likes.count
                state.placeName = post.content1
                state.placeAddress = post.content2
                state.placeLink = post.content3
                state.images = post.files
                state.visitedDate = post.content4
                
                if let creatorName = post.creator.nick {
                    state.postCreatorName = creatorName
                    print(state.postCreatorName)
                }
                
                if let creatorProfile = post.creator.profileImage {
                    state.postCreatorProfile = creatorProfile
                    print(state.postCreatorProfile)
                }
                state.comments = post.comments.sorted(by: { $0.createdAt ?? "" < $1.createdAt ?? "" })
                state.lat = post.geolocation.latitude
                state.lon = post.geolocation.longitude
                state.isLiked = post.likes.contains(where: { $0 == UserDefaultsManager.userID })
                if let category = Category(rawValue: post.category), let image = category.image {
                    state.categoryImage = image
                }
                state.isLoading = false
                
                return .none
                
            case .fetchError(let error):
                state.isLoading = false
                print(error)
                return .none
                
            case .toggleLiked:
                state.isLiked.toggle()
                return .none
                
            case .dismiss:
                let postID = state.postID
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
                
            case .showPlaceWebView:
                state.showPlaceWebView = true
                return .none
            }
        }
    }
}
