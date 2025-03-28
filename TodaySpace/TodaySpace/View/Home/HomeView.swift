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
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 60)
        }
        .background(AppColor.appBackground)
        .customNavigationBar(centerView: {
            HStack(alignment: .center) {
                Text("Today Space")
                    .appFontBold(size: 28).bold()
                    .fontDesign(.serif)
                    .foregroundStyle(AppColor.appGold)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }, leftView: {
            EmptyView()
        }, rightView: {
            writePostButton()
        })
        .onAppear {
            store.send(.viewAppear)
        }
        .fullScreenCover(item: $store.scope(state: \.writePost, action: \.writePost)) { store in
            WritePostView(store: store)
        }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        VStack {
            categoryView()
                .padding(.top, 10)
                .padding(.bottom, 5)
            
            switch store.state.viewState {
            case .loading:
                CustomProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                ContentUnavailableView {
                    VStack(alignment: .center, spacing: 20) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                        
                        Text("첫 게시물의 주인공이 되어보세요!")
                            .appFontBold(size: 20)
                    }
                    .foregroundStyle(AppColor.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .content:
                listView()
            }
        }
    }
    
    @ViewBuilder
    private func listView() -> some View {
        VStack {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - (40)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(store.posts.enumerated()), id: \.element.post_id) { index, post in
                            VStack(alignment: .leading, spacing: 10) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.clear)
                                    .background {
                                        ZStack {
                                            ImageView(
                                                imageURL: post.files.first,
                                                frame: .setFrame(availableWidth, availableWidth - 150),
                                                errorImage: Image(systemName: "exclamationmark.triangle.fill")
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.clear, AppColor.black.opacity(0.4), AppColor.black.opacity(0.8)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            VStack {
                                                roundCategoryView(title: post.category, foregroundColor: AppColor.white, backgroundColor: AppColor.appGold, strokeColor: AppColor.gray)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Spacer()
                                                
                                                VStack(spacing: 10) {
                                                    Text("\(post.content1)")
                                                        .appFontBold(size: 24).bold()
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                    
                                                    Text("\(post.content2)")
                                                        .appFontBold(size: 14)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                }
                                            }
                                            .padding(10)
                                        }
                                    }
                                    .frame(width: availableWidth, height: availableWidth - 150)
                                
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("\(post.title)").bold()
                                        .appFontBold(size: 20)
                                        .foregroundStyle(AppColor.white)
                                        .lineLimit(1)
                                    
                                    HStack(alignment: .center, spacing: 10) {
                                        HStack(alignment: .center, spacing: 5) {
                                            Text("\(post.creator.nick ?? "알 수 없는 유저")")
                                                .foregroundStyle(AppColor.white)
                                                .appFontBold(size: 14)
                                            
                                            Text("\(DateFormatter.convertDateString(post.createdAt, type: .formatted))")
                                                .appFontBold(size: 12)
                                                .foregroundStyle(AppColor.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(alignment: .bottom, spacing: 10) {
                                            HStack(alignment: .center, spacing: 5) {
                                                    Image(systemName: "star.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(AppColor.gray)
                                                        .frame(width: 15, height: 15)
                                                        .bold()
                                                
                                                Text("\(post.likes.count.decimalString)")
                                                    .appFontBold(size: 12)
                                                    .foregroundStyle(AppColor.gray)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            
                                            HStack(alignment: .center, spacing: 5) {
                                                Image(systemName: "text.bubble.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundStyle(AppColor.gray)
                                                    .frame(width: 15, height: 15)
                                                    .bold()
                                                
                                                Text("\(post.comments.count.decimalString)")
                                                    .appFontBold(size: 12)
                                                    .foregroundStyle(AppColor.gray)
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }
                                    }
                                }
                            }
                            .contentShape(Rectangle())
                            .padding(.bottom, 5)
                            .onTapGesture {
                                store.send(.postDetail(post.post_id))
                            }
                            .onAppear {
                                if index == store.posts.count - 1, store.state.nextCursor != "0" {
                                    store.send(.pagination)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .scrollIndicators(.never)
                .refreshable {
                    try? await Task.sleep(for: .seconds(1))
                    store.send(.refreshing)
                }
            }
        }
    }
    
    @ViewBuilder
    func categoryView() -> some View {
        HStack(spacing: 20) {
            roundCategoryView(title: "ALL", foregroundColor: AppColor.white, backgroundColor: store.state.categoryFilter == .all ? AppColor.appGold : .clear, strokeColor: AppColor.gray, strokeLineWidth: 0.5) {
                store.send(.setCategory(.all))
            }
            .animation(.easeInOut(duration: 0.2), value: store.state.categoryFilter)
            
            ForEach(Category.allCases, id: \ .id) { category in
                roundCategoryView(title: category.rawValue, image: category.image, foregroundColor: AppColor.white, backgroundColor: isSelected(category.id) ? AppColor.appGold : .clear, strokeColor: AppColor.gray, strokeLineWidth: 0.5) {
                    store.send(.setCategory(.selected(category.id)))
                }
                .animation(.easeInOut(duration: 0.2), value: store.state.categoryFilter)
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
        .tint(AppColor.white)
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
