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
            
            ZStack {
                switch store.state.viewType {
                case .postList:
                    VStack(spacing: 12) {
                        categoryView()
                            .padding(.top, 10)
                        
                        ScrollView {
                            LazyVGrid(columns: store.columns) {
                                ForEach(0..<60, id: \ .self) { value in
                                    Button {
                                        store.send(.tokenRefresh)
                                    } label: {
                                        RoundedRectangle(cornerRadius: 8)
                                    }
                                    .frame(width: 180, height: 250)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    
                case .mapView:
                    MapView()
                    VStack {
                        categoryView()
                            .padding(.top, 10)
                        Spacer()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            store.send(.showWritePostSheet)
                        } label: {
                            Image(systemName: "square.and.pencil.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.background, .foreground)
                                .frame(width: 50, height: 50)
                        }
                        .shadow(radius: 3)
                    }
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                }
            }
        }
        .background(AppColor.appBackground)
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        VStack {
            HStack(alignment: .center) {
                Text("오늘의 공간")
                    .font(.system(size: 25, weight: .black))
                    .foregroundColor(AppColor.main)
                
                Spacer()
                
                Button {
                    store.send(.switchViewType(store.viewType))
                } label: {
                    Image(systemName: store.viewType == .postList ? "map.fill" : "list.dash")
                        .frame(width: 40, height: 40)
                        .foregroundColor(AppColor.main)
                }
            }
            .padding()
        }
        .frame(height: 35)
        .fullScreenCover(isPresented: $store.showWritePostSheet) {
            WritePostView(store: store.scope(state: \ .writePost, action: \ .writePost))
        }
    }
    
    @ViewBuilder
    func categoryView() -> some View {
        HStack(alignment: .center, spacing: 10) {
            ForEach(Category.allCases, id: \ .id) { category in
                HStack {
                    HStack(spacing: 10) {
                        if let image = category.image {
                            Image(systemName: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                        }
                        
                        Text(category.rawValue)
                            .font(.system(size: 15))
                    }
                    .frame(height: 20)
                    .foregroundStyle(
                        isSelected(category.id) ? AppColor.appBackground : AppColor.main
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(AppColor.grayStroke, lineWidth: 1)
                            .fill(isSelected(category.id) ? AppColor.main : AppColor.appBackground)
                            .animation(.easeInOut(duration: 0.2), value: store.state.categoryFilter)
                            .shadow(radius: 0.3)
                    )
                }
                .onTapGesture {
                    if category == .all, store.state.categoryFilter == .all { return }
                    store.send(.setCategory(category.id))
                }
            }
        }
        .frame(height: 30)
    }
    
    private func isSelected(_ categoryID: String) -> Bool {
        if store.state.categoryFilter == .all, categoryID == Category.all.id {
            return true
        }
        if case .selected(let selectedID) = store.state.categoryFilter {
            return categoryID == selectedID
        }
        return false
    }
}
