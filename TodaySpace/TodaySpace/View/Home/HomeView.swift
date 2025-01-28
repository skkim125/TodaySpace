//
//  HomeView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        VStack {
            switch store.state.viewType {
            case .postList:
                Button {
                    store.send(.tokenRefresh)
                } label: {
                    Text("리프래시토큰 갱신")
                }
            case .mapView:
                MapView()
            }
            
            Button("버튼: 뷰 전환") {
                store.send(.switchViewType(store.viewType))
            }
            .padding(.top)
        }
    }
}
