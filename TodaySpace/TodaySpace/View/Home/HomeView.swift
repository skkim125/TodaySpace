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
        VStack {
            contentView()
                .padding(.vertical, 5)
        }
        .background(AppColor.appBackground)
        .customNavigationBar(centerView: {
            HStack {
                Text("오늘의 공간")
                    .font(.system(size: 25, weight: .black))
                    .foregroundStyle(AppColor.main)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }, leftView: {
            EmptyView()
        }, rightView: {
            writePostButton()
        })
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
            
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - (40)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(store.posts, id: \.post_id) { post in
                            VStack(alignment: .leading, spacing: 10) {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColor.grayStroke, lineWidth: 0.1)
                                    .background {
                                        ImageView(
                                            imageURL: post.files.first,
                                            frame: .setFrame(availableWidth, availableWidth - 150)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .opacity(0.7)
                                    }
                                    .frame(width: availableWidth, height: availableWidth - 150)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack(alignment: .lastTextBaseline, spacing: 5) {
                                        Text("\(post.title)")
                                            .font(.title3).bold()
                                            .foregroundStyle(.white)
                                            .lineLimit(1)
                                        
                                        Text("\(DateFormatter.convertDateString(post.createdAt, type: .formatted))")
                                            .font(.caption)
                                            .foregroundStyle(AppColor.gray)
                                    }
                                    
                                    Text("\(post.content1)")
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                }
                            }
                            .contentShape(Rectangle())
                            .padding(.bottom, 5)
                            .onTapGesture {
                                store.send(.postDetail(post.post_id))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                }
            }
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
