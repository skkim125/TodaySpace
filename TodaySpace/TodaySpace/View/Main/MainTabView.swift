//
//  MainTabView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    @Bindable var store: StoreOf<MainTabFeature>
    
    init(store: StoreOf<MainTabFeature>) {
        self.store = store
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
    
    var body: some View {
        TabView(selection: $store.selectedTab) {
            
            HomeView(store: store.scope(state: \.home, action: \.home))
                .tabItem {
                    Image(systemName: TabInfo.home.image)
                }
                .tag(TabInfo.home)
            
            ContentView()
                .tabItem {
                    Image(systemName: TabInfo.search.image)
                }
                .tag(TabInfo.search)
            
            ContentView()
                .tabItem {
                    Image(systemName: TabInfo.dm.image)
                }
                .tag(TabInfo.dm)
            
            ContentView()
                .tabItem {
                    Image(systemName: TabInfo.myPage.image)
                }
                .tag(TabInfo.myPage)
        }
        .tint(Color(uiColor: .label))
    }
}
