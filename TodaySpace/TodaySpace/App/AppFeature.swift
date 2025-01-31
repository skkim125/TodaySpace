//
//  AppFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct AppFeature {
    
    enum LoginState {
        case success
        case loading
    }
    
    @ObservableState
    struct State {
        var loginState: LoginState = .success
        var login = LoginFeature.State()
        var mainTab = MainTabFeature.State()
    }
    
    enum Action {
        case updateLoginState(LoginState)
        case login(LoginFeature.Action)
        case mainTab(MainTabFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.login, action: \.login) {
            LoginFeature()
        }
        Scope(state: \.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .login(.loginSuccess):
                return .send(.updateLoginState(.success), animation: .easeIn)
            
            case .login(.loginFailure):
                print("로그인 실패")
                return .none
                
            case .login:
                return .none
                
            case .mainTab:
                return .none
                
            case let .updateLoginState(newState):
                state.loginState = newState
                return .none
            }
        }
    }
}
