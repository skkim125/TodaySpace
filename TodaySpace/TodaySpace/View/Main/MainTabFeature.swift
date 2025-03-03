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
        var mapList = MapListFeature.State()
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
        case mapList(MapListFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case updatePost(PostResponse)
        case deletePost(String)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Scope(state: \.mapList, action: \.mapList) {
            MapListFeature()
        }
        
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .home(.postDetail(let postID)):
                state.path.append(.postDetail(PostDetailFeature.State(postID: postID)))
                return .none
            case .mapList(.postDetail(let postID)):
                state.path.append(.postDetail(PostDetailFeature.State(postID: postID)))
                return .none
                
            case .path(.element(id: _, action: .postDetail(.dismissAction(let action)))):
                switch action {
                case .dismiss(let post):
                    return .send(.updatePost(post))
                case .afterDelete(let id):
                    return .send(.deletePost(id))
                }
                
            case .deletePost(let id):
                switch state.selectedTab {
                case .home:
                    return .run { send in
                        await send(.home(.deletePost(id)))
                    }
                case .map:
                    return .run { send in
                        await send(.mapList(.deletePost(id)))
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
                    if let index = state.mapList.posts.firstIndex(where: { $0.post_id == post.post_id }) {
                        state.mapList.posts[index] = post
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
                
            case .mapList(.dismissAfterFetch):
                if !state.path.isEmpty {
                    state.path.removeLast()
                }
                return .none
                
            case .mapList:
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
