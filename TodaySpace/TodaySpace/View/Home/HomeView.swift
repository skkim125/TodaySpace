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
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                contentView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("오늘의 공간")
                        .font(.system(size: 25, weight: .black))
                        .foregroundStyle(AppColor.main)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if store.posts.isEmpty {
                            store.send(.switchViewType(store.viewType))
                        } else {
                            store.send(.switchViewType(store.viewType))
                        }
                    } label: {
                        Image(systemName: store.viewType == .postList ? "map.fill" : "list.dash")
                            .frame(width: 40, height: 40)
                            .foregroundStyle(AppColor.main)
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case .postDetail(let store):
                LazyInitView {
                    PostDetailView(store: store)
                }
            }
        }
        .background(AppColor.appBackground)
        .onAppear {
            if !store.viewAppeared {
                store.send(.viewAppear)
            }
        }
        .fullScreenCover(item: $store.scope(state: \.writePost, action: \.writePost)) { store in
            WritePostView(store: store)
        }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        ZStack {
            if !store.posts.isEmpty {
                listView(viewType: store.viewType)
            } else {
                ContentUnavailableView {
                    VStack(alignment: .center, spacing: 20) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                        
                        Text("첫 게시물의 주인공이 되어보세요!")
                            .font(.headline)
                    }
                    .foregroundStyle(.gray)
                }
            }
            
            writePostButton()
                .padding(.trailing, 15)
                .padding(.bottom, 15)
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
                                store.send(.postDetail(post))
                            } label: {
                                HStack {
                                    ImageView(imageURL: post.files?.first, frame: .setFrame(150, 150))
                                    
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
            LazyInitView {
                MapView()
            }
            
            VStack {
                categoryView()
                    .padding(.top, 10)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func categoryView() -> some View {
        HStack {
            categoryButton(title: "ALL", foregroundColor: store.state.categoryFilter == .all ? AppColor.appBackground : AppColor.main, backgroundColor: store.state.categoryFilter == .all ? AppColor.main : AppColor.appBackground, animationValue: store.state.categoryFilter) {
                store.send(.setCategory(.all))
            }
            
            ForEach(Category.allCases, id: \ .id) { category in
                categoryButton(title: category.rawValue, image: category.image, foregroundColor: isSelected(category.id) ? AppColor.appBackground : AppColor.main, backgroundColor: isSelected(category.id) ? AppColor.main : AppColor.appBackground, animationValue: store.state.categoryFilter) {
                    store.send(.setCategory(.selected(category.id)))
                }
            }
        }
        .frame(height: 20)
    }
    
    @ViewBuilder
    func writePostButton() -> some View {
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
        }
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
