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
            navigationBar()
            switch store.state.viewType {
            case .postList:
                ScrollView {
                    Button {
                        store.send(.tokenRefresh)
                    } label: {
                        Text("리프래시토큰 갱신")
                    }
                    .padding(.top)
                }
            case .mapView:
                MapView()
            }
        }
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        VStack {
            HStack {
                Text("오늘의 공간")
                    .font(.system(size: 25))
                    .fontWeight(.black)
                    .fontDesign(.serif)
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button {
                        store.send(.showWritePostSheet)
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 20))
                    }
                    
                    Button {
                        store.send(.switchViewType(store.viewType))
                    } label: {
                        Image(systemName: store.viewType == .postList ? "map.fill" : "list.dash")
                            .font(.system(size: 20))
                    }
                }
            }
            .padding()
        }
        .frame(height: 30)
        .fullScreenCover(isPresented: $store.showWritePostSheet) {
            WritePostView(store: store.scope(state: \.writePost, action: \.writePost))
        }
    }
}
