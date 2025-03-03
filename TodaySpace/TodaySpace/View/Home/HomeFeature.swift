//
//  HomeFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import ComposableArchitecture

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

enum HomeViewState {
    case loading
    case empty
    case content
}


@Reducer
struct HomeFeature: Reducer {
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.postClient) var postClient
    
    @ObservableState
    struct State {
        var viewState: HomeViewState = .loading
        var posts: [PostResponse] = []
        @Presents var writePost: WritePostFeature.State?
        var categoryFilter: CategoryFilter = .all
        var selectedPost: PostResponse?
        var newFetch: Bool = false
        var nextCursor: String = "0"
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
        case writePost(PresentationAction<WritePostFeature.Action>)
        case setCategory(CategoryFilter)
        case fetchPost(FetchPostQuery)
        case fetchSuccess(FetchPostResponse)
        case requestError(Error)
        case postDetail(String)
        case dismissAfterFetch
        case refreshing
        case pagination
        case deletePost(String)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .refreshing:
                state.newFetch = true
                state.nextCursor = "0"
                return .run { [nextCursor = state.nextCursor, selectedCategory = state.selectedCategory] send in
                    await send(.fetchPost(FetchPostQuery(next: nextCursor, category: selectedCategory)))
                }

            case .viewAppear:
                if state.viewState == .loading {
                    return .run { [nextCursor = state.nextCursor, selectedCategory = state.selectedCategory] send in
                        await send(.fetchPost(FetchPostQuery(next: nextCursor, category: selectedCategory)))
                    }
                } else {
                    return .none
                }
                
            case .requestError(let error):
                if let error = error as? ErrorType {
                    print(error.message)
                } else if let error = error as? NetworkError {
                    print(error.errorDescription)
                }
                state.viewState = .empty
                return .none
                
            case .showWritePostSheet:
                state.writePost = WritePostFeature.State()
                return .none
            case .writePost(.presented(.dismiss)):
                state.writePost = nil
                state.nextCursor = "0"
                state.newFetch = true
                return .send(.fetchPost(FetchPostQuery(next: state.nextCursor, category: state.selectedCategory)))
            case .writePost:
                return .none
            case .setCategory(let categoryType):
                if state.categoryFilter != categoryType {
                    state.viewState = .loading
                    state.nextCursor = "0"
                    state.newFetch = true
                    
                    switch categoryType {
                    case .all:
                        state.categoryFilter = .all
                        return .send(.fetchPost(FetchPostQuery(next: state.nextCursor, category: state.selectedCategory)))
                        
                    case .selected(let categoryId):
                        state.categoryFilter = .selected(categoryId)
                        return .send(.fetchPost(FetchPostQuery(next: state.nextCursor, category: state.selectedCategory)))
                    }
                } else {
                    return .none
                }
                
            case .pagination:
                return .send(.fetchPost(FetchPostQuery(next: state.nextCursor, category: state.selectedCategory)))
                
            case .fetchPost(let body):
                if !state.newFetch, !state.posts.isEmpty && state.nextCursor == "0" {
                    return .none
                }
                
                return .run { send in
                    do {
                        let result = try await postClient.fetchPost(body)
                        try await Task.sleep(for: .milliseconds(150))
                        return await send(.fetchSuccess(result))
                    } catch {
                        return await send(.requestError(error))
                    }
                }
                
            case .fetchSuccess(let result):
                if state.newFetch {
                    state.posts = result.data
                    state.newFetch = false
                } else {
                    state.posts.append(contentsOf: result.data)
                }
                state.nextCursor = result.next_cursor
                print(state.nextCursor)
                state.viewState = result.data.isEmpty ? .empty : .content
                
                return .none
                
            case .deletePost(let id):
                state.posts.removeAll(where: { $0.post_id == id })
                
                return .run { send in
                    await send(.dismissAfterFetch)
                }
                
            case .dismissAfterFetch:
                return .none
                
            case .postDetail:
                return .none
            }
        }
        .ifLet(\.$writePost, action: \.writePost) {
            WritePostFeature()
        }
    }
}
