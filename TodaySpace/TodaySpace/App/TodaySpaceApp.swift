//
//  TodaySpaceApp.swift
//  TodaySpace
//
//  Created by 김상규 on 1/22/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct TodaySpaceApp: App {
    var store: StoreOf<AppFeature> = .init(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            onboardingView()
        }
    }
    
    @ViewBuilder
    func onboardingView() -> some View {
        switch store.loginState {
        case .loading:
            LoginView(store: store.scope(state: \.login, action: \.login))
        case .success:
            MainTabView(store: store.scope(state: \.mainTab, action: \.mainTab))
        }
    }
}
