//
//  HomeFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import ComposableArchitecture

struct PlaceCategory: Identifiable {
    let id: String
    let image: String?
    let name: String
}

enum Category: String, CaseIterable {
    case restaurant = "식당"
    case cafe = "카페"
    case landmark = "명소"
    case shopping = "쇼핑"
    
    var id: String {
        return self.rawValue
    }
    
    var image: String? {
        switch self {
        case .restaurant:
            "fork.knife"
        case .cafe:
            "cup.and.saucer.fill"
        case .landmark:
            "building.columns.fill"
        case .shopping:
            "cart.fill"
        }
    }
}

enum CategoryFilter: Equatable {
    case all
    case selected(String)
}

@Reducer
struct HomeFeature: Reducer {
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.postClient) var postClient
    
    enum HomeViewType {
        case postList
        case mapView
    }
    
    @Reducer
    enum Path {
        case postDetail(PostDetailFeature)
    }
    
    @ObservableState
    struct State {
        var viewType: HomeViewType = .postList
        var viewAppeared = false
        var posts: [PostResponse] = []
        var path = StackState<Path.State>()
        @Presents var writePost: WritePostFeature.State?
        var categoryFilter: CategoryFilter = .all
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        var selectedCategory: [String] {
            switch categoryFilter {
            case .all:
                return Category.allCases.map { $0.rawValue }
            case .selected(let id):
                return [id]
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case viewAppear
        case showWritePostSheet
        case tokenRefresh
        case refreshSuccess(TokenResponse)
        case switchViewType(HomeViewType)
        case writePost(PresentationAction<WritePostFeature.Action>)
        case setCategory(CategoryFilter)
        case fetchPost(FetchPostQuery)
        case fetchSuccess(FetchPostResult)
        case requestError(Error)
        case postDetail(PostResponse)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .viewAppear:
                if !state.viewAppeared {
                    state.viewAppeared = true
                    return .run { send in
                       await send(.fetchPost(FetchPostQuery(next: "0", limit: "20", category: [])))
                    }
                } else {
                    return .none
                }
            case .tokenRefresh:
                return .run { send in
                    do {
                        let result = try await authClient.tokenRefresh()
                        return await send(.refreshSuccess(result))
                    } catch {
                        return await send(.requestError(error))
                    }
                }
                
            case .refreshSuccess(let token):
                UserDefaultsManager.refresh(token.accessToken, token.refreshToken)
                print("리프래시 완료")
                return .none
                
            case .requestError(let error):
                print(error)
                return .none
                
            case .switchViewType(let viewType):
                switch viewType {
                case .postList:
                    state.viewType = .mapView
                case .mapView:
                    state.viewType = .postList
                }
                return .none
            case .showWritePostSheet:
                state.writePost = WritePostFeature.State()
                return .none
            case .writePost(.presented(.dismiss)):
                state.writePost = nil
                return .send(.fetchPost(FetchPostQuery(next: "0", limit: "20", category: [])))
            case .writePost:
                return .none
            case .setCategory(let categoryType):
                
                switch categoryType {
                case .all:
                    state.categoryFilter = .all
                    
                case .selected(let categoryId):
                    if state.categoryFilter == .selected(categoryId) {
                        state.categoryFilter = .all
                    } else {
                        state.categoryFilter = .selected(categoryId)
                    }
                }
                
                return .none
                
            case .fetchPost(let body):
                return .run { send in
                    do {
                        let result = try await postClient.fetchPost(body)
                        return await send(.fetchSuccess(result))
                    } catch {
                        return await send(.requestError(error))
                    }
                }
                
            case .fetchSuccess(let result):
                state.posts = result.data
                return .none
            case .postDetail(let post):
                state.path.append(.postDetail(PostDetailFeature.State(post: post)))
                return .none
            case .path:
                return .none
            }
        }
        .ifLet(\.$writePost, action: \.writePost) {
            WritePostFeature()
        }
        .forEach(\.path, action: \.path)
    }
}
