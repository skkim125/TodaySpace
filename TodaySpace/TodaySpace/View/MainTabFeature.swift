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
    case search = "검색"
    case dm = "DM"
    case myPage = "마이페이지"
    
    var image: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
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
    struct State: Equatable {
        var selectedTab: TabInfo = .home
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
