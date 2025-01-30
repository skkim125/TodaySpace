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
    case all = "ALL"
    case restaurant = "식당"
    case cafe = "카페"
    case landmark = "명소"
    case shopping = "쇼핑"
    
    var id: String {
        return self.rawValue
    }
    
    var image: String? {
        switch self {
        case .all:
            nil
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
    
    enum HomeViewType {
        case postList
        case mapView
    }
    
    @ObservableState
    struct State {
        var viewType: HomeViewType = .postList
        var writePost = WritePostFeature.State()
        var showWritePostSheet = false
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
        case showWritePostSheet
        case tokenRefresh
        case refreshSuccess(TokenResponse)
        case refreshFailure(Error)
        case switchViewType(HomeViewType)
        case writePost(WritePostFeature.Action)
        case setCategory(String)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.writePost, action: \.writePost) {
            WritePostFeature()
        }
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .tokenRefresh:
                return .run { send in
                    do {
                        let result = try await authClient.tokenRefresh()
                        return await send(.refreshSuccess(result))
                    } catch {
                        return await send(.refreshFailure(error))
                    }
                }
                
            case .refreshSuccess(let token):
                UserDefaultsManager.refresh(token.accessToken, token.refreshToken)
                print("리프래시 완료")
                return .none
                
            case .refreshFailure(let error):
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
                state.showWritePostSheet = true
                return .none
            case .writePost:
                return .none
            case .setCategory(let categoryID):
                switch state.categoryFilter {
                case .all:
                    // 아무것도 선택되지 않은 상태에서 카테고리 선택
                    state.categoryFilter = .selected(categoryID)
                case .selected(let currentCategoryID):
                    // 이미 선택된 카테고리를 다시 선택한 경우 -> all로 변경
                    if currentCategoryID == categoryID {
                        state.categoryFilter = .all
                    } else {
                        // 다른 카테고리 선택
                        state.categoryFilter = .selected(categoryID)
                    }
                }
                
                print(state.categoryFilter)
                return .none
            }
        }
    }
}
