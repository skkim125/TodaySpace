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
    
    enum HomeViewType {
        case postList
        case mapView
    }
    
    @ObservableState
    struct State {
        var viewType: HomeViewType = .postList
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
        case showWritePostSheet
        case tokenRefresh
        case refreshSuccess(TokenResponse)
        case refreshFailure(Error)
        case switchViewType(HomeViewType)
        case writePost(PresentationAction<WritePostFeature.Action>)
        case setCategory(String)
    }
    
    var body: some ReducerOf<Self> {
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
                state.writePost = WritePostFeature.State()
                return .none
            case .writePost(.presented(.dismiss)):
                state.writePost = nil
                return .none
            case .writePost:
                return .none
            case .setCategory(let categoryID):
                switch state.categoryFilter {
                case .all:
                    
                    state.categoryFilter = .selected(categoryID)
                case .selected(let currentCategoryID):
                    
                    if currentCategoryID == categoryID {
                        state.categoryFilter = .all
                    } else {
                        
                        state.categoryFilter = .selected(categoryID)
                    }
                }
                
                print(state.categoryFilter)
                return .none
            }
        }
        .ifLet(\.$writePost, action: \.writePost) {
            WritePostFeature()
        }
    }
}
