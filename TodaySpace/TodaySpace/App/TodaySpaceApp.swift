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
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColor.appBackground)
        appearance.backgroundEffect = nil
        appearance.shadowColor = .gray
        
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
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
