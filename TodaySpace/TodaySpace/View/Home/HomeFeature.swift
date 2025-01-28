//
//  HomeFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import Foundation
import ComposableArchitecture

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
        var category: PlaceCategory?
        var writePost = WritePostFeature.State()
        var showWritePostSheet = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case showWritePostSheet
        case tokenRefresh
        case refreshSuccess(TokenResponse)
        case refreshFailure(Error)
        case switchViewType(HomeViewType)
        case writePost(WritePostFeature.Action)
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
            }
        }
    }
}
