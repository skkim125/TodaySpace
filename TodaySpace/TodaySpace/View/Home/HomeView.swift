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
    
    var body: some View {
        NavigationStack {
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
                    writePostButton()
                }
            }
            .background(AppColor.appBackground)
            .onAppear {
                if !store.viewAppeared {
                    store.send(.viewAppear)
                }
            }
            .sheet(isPresented: $store.showSheet) {
                if let post = store.selectedPost {
                    ZStack {
                        Color(uiColor: .systemBackground)
                            .ignoresSafeArea()
                        LazyInitView {
                            PostDetailView(store: .init(initialState: PostDetailFeature.State(post: post), reducer: {
                                PostDetailFeature()
                            }))
                        }
                    }
                }
            }
            .fullScreenCover(item: $store.scope(state: \.writePost, action: \.writePost)) { store in
                WritePostView(store: store)
            }
        }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        ZStack {
            if !store.posts.isEmpty {
                listView()
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
        }
    }
    
    @ViewBuilder
    private func listView() -> some View {
        VStack {
            categoryView()
                .padding(.top, 10)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(store.posts, id: \.post_id) { post in
                        HStack {
                            ImageView(imageURL: post.files?.first, frame: .setFrame(150, 150))
                            
                            Text("\(post.title)")
                        }
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            store.send(.showSheet(post))
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    func categoryView() -> some View {
        HStack(spacing: 15) {
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
        Button {
            store.send(.showWritePostSheet)
        } label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
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
