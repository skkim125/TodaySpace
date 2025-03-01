//
//  MainTabFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation
import ComposableArchitecture

enum TabInfo: String {
    case home = "홈"
    case map = "내주변"
    case dm = "DM"
    case myPage = "마이페이지"
    
    var image: String {
        switch self {
        case .home:
            return "house"
        case .map:
            return "map"
        case .dm:
            return "message"
        case .myPage:
            return "person.crop.circle"
        }
    }
}

@Reducer
struct MainTabFeature {

    @ObservableState
    struct State {
        var selectedTab: TabInfo = .home
        var home = HomeFeature.State()
        var map = MapViewFeature.State()
        var showDetailView: Bool = false
        var path = StackState<Path.State>()
    }
    
    @Reducer
    enum Path {
        case postDetail(PostDetailFeature)
        enum Action {
            case postDetail(PostDetailFeature.Action)
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case home(HomeFeature.Action)
        case map(MapViewFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case updatePost(PostResponse)
        case fetchPost
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Scope(state: \.map, action: \.map) {
            MapViewFeature()
        }
        
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .home(.postDetail(let postID)):
                state.path.append(.postDetail(PostDetailFeature.State(postID: postID)))
                return .none
            case .map(.postDetail(let postID)):
                state.path.append(.postDetail(PostDetailFeature.State(postID: postID)))
                return .none
                
            case .path(.element(id: _, action: .postDetail(.dismissAction(let action)))):
                switch action {
                case .dismiss(let post):
                    return .send(.updatePost(post))
                case .afterDelete:
                    return .send(.fetchPost)
                }
                
            case .fetchPost:
                switch state.selectedTab {
                case .home:
                    let category = state.home.selectedCategory
                    return .run { send in
                        await send(.home(.fetchPost(FetchPostQuery(next: "0", limit: "20", category: category))))
                    }
                case .map:
                    let coodinate = state.map.currentRegion.center
                    return .run { send in
                        await send(.map(.searchPost(coodinate)))
                    }
                default:
                    return .none
                }
                
            case .updatePost(let post):
                switch state.selectedTab {
                case .home:
                    if let index = state.home.posts.firstIndex(where: { $0.post_id == post.post_id }) {
                        state.home.posts[index] = post
                    }
                case .map:
                    if let index = state.map.posts.firstIndex(where: { $0.post_id == post.post_id }) {
                        state.map.posts[index] = post
                    }
                default:
                    break
                }
                return .none
                
            case .home(.dismissAfterFetch):
                if !state.path.isEmpty {
                    state.path.removeLast()
                }
                return .none
                
            case .home:
                return .none
                
            case .map(.dismissAfterFetch):
                if !state.path.isEmpty {
                    state.path.removeLast()
                }
                return .none
                
            case .map:
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
