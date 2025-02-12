//
//  HomeView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

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
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            navigationBar()
            
            ZStack {
                listView(viewType: store.viewType)
                
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
                                .background {
                                    Circle()
                                        .stroke(AppColor.appBackground,lineWidth: 1)
                                }
                        }
                    }
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                }
            }
        }
        .background(AppColor.appBackground)
        .onAppear {
            if !store.viewAppeared {
                store.send(.viewAppear)
            }
        }
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        VStack {
            HStack(alignment: .center) {
                Text("오늘의 공간")
                    .font(.system(size: 25, weight: .black))
                    .foregroundStyle(AppColor.main)
                
                Spacer()
                
                Button {
                    store.send(.switchViewType(store.viewType))
                } label: {
                    Image(systemName: store.viewType == .postList ? "map.fill" : "list.dash")
                        .frame(width: 40, height: 40)
                        .foregroundStyle(AppColor.main)
                }
            }
            .padding()
        }
        .frame(height: 35)
        .fullScreenCover(item: $store.scope(state: \.writePost, action: \.writePost)) { store in
            WritePostView(store: store)
        }
    }
    
    @ViewBuilder
    private func listView(viewType: HomeFeature.HomeViewType) -> some View {
        switch store.state.viewType {
        case .postList:
            VStack {
                categoryView()
                    .padding(.top, 10)
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(store.posts, id: \.post_id) { post in
                            Button {
                                print(post)
                            } label: {
                                HStack {
                                    ImageView(imageURL: post.files?.first)
                                    
                                    Text("\(post.title)")
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top, 10)
            }
            
        case .mapView:
            MapView()
            VStack {
                categoryView()
                    .padding(.top, 10)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func categoryView() -> some View {
        HStack(alignment: .center, spacing: 10) {
            HStack {
                HStack(spacing: 10) {
                    Text("ALL")
                        .font(.system(size: 14))
                }
                .frame(height: 20)
                .foregroundStyle(
                    store.state.categoryFilter == .all ? AppColor.appBackground : AppColor.main
                )
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(AppColor.main, lineWidth: 0.7)
                        .fill(store.state.categoryFilter == .all ? AppColor.main : AppColor.appBackground)
                        .animation(.easeInOut(duration: 0.2), value: store.state.categoryFilter)
                )
            }
            .onTapGesture {
                store.send(.setCategory(.all))
            }
            
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
                            .font(.system(size: 14))
                    }
                    .frame(height: 20)
                    .foregroundStyle(
                        isSelected(category.id) ? AppColor.appBackground : AppColor.main
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(AppColor.main, lineWidth: 0.7)
                            .fill(isSelected(category.id) ? AppColor.main : AppColor.appBackground)
                            .animation(.easeInOut(duration: 0.2), value: store.state.categoryFilter)
                    )
                }
                .onTapGesture {
                    store.send(.setCategory(.selected(category.id)))
                }
            }
        }
        .frame(height: 30)
    }
}

extension HomeView {
    private func isSelected(_ categoryID: String) -> Bool {
        if case .selected(let selectedID) = store.state.categoryFilter {
            return categoryID == selectedID
        }
        return false
    }
}
