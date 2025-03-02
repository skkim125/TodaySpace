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
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TabView(selection: $store.selectedTab) {
                HomeView(store: store.scope(state: \.home, action: \.home))
                    .tag(TabInfo.home)
                MapListView(store: store.scope(state: \.map, action: \.map))
                    .tag(TabInfo.map)
                ContentView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(TabInfo.dm)
                ContentView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(TabInfo.myPage)
            }
            .tabViewStyle(DefaultTabViewStyle())
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $store.selectedTab)
            }
        } destination: { store in
            switch store.case {
            case .postDetail(let store):
                PostDetailView(store: store)
            }
        }
    }
}
