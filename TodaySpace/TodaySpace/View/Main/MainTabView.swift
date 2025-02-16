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
    
    var body: some View {
        TabView(selection: $store.selectedTab) {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .tabItem {
                    Image(systemName: TabInfo.home.image)
                }
                .tag(TabInfo.home)
            
            MapView()
                .tabItem {
                    Image(systemName: TabInfo.map.image)
                }
                .tag(TabInfo.map)
            
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
