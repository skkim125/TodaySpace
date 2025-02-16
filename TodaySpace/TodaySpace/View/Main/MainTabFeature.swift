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
    case map = "지도"
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
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case home(HomeFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .home:
                return .none
            }
        }
    }
}
