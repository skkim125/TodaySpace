//
//  MainTabView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabInfo = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            
            ContentView()
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
        .tint(.purple)
    }
}
