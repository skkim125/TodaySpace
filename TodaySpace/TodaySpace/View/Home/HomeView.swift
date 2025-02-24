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
        .background(AppColor.appBackground)
        .customNavigationBar(centerView: {
            HStack(alignment: .center) {
                Text("Today Space")
                    .font(.title)
                    .fontDesign(.serif)
                    .bold()
                    .foregroundStyle(.appGold)
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
        ZStack {
            switch store.state.viewState {
            case .loading:
                ProgressView()
            case .empty:
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
            case .content:
                listView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func listView() -> some View {
        VStack {
            categoryView()
                .padding(.vertical, 5)
            
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - (40)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(store.posts, id: \.post_id) { post in
                            VStack(alignment: .leading, spacing: 10) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.clear)
                                    .background {
                                        ZStack {
                                            ImageView(
                                                imageURL: post.files.first,
                                                frame: .setFrame(availableWidth, availableWidth - 150)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.4), Color.black.opacity(0.8)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            
                                            VStack(spacing: 5) {
                                                roundCategoryView(title: post.category, foregroundColor: Color.white, backgroundColor: .appGold, strokeColor: AppColor.gray)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Spacer()
                                                
                                                Text("\(post.content1)")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .fontDesign(.rounded)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                
                                                Text("\(post.content2)")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .fontDesign(.rounded)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .padding(10)
                                        }
                                    }
                                    .frame(width: availableWidth, height: availableWidth - 150)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(alignment: .center, spacing: 5) {
                                        Text("\(post.title)")
                                            .font(.title3).bold()
                                            .foregroundStyle(.white)
                                            .lineLimit(1)
                                        
                                        Text("\(DateFormatter.convertDateString(post.createdAt, type: .formatted))")
                                            .font(.caption)
                                            .foregroundStyle(AppColor.gray)
                                    }
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
            roundCategoryView(title: "ALL", foregroundColor: .white, backgroundColor: store.state.categoryFilter == .all ? .appGold : .clear, strokeColor: AppColor.gray, strokeLineWidth: 0.5) {
                store.send(.setCategory(.all))
            }
            .animation(.easeInOut(duration: 0.2), value: store.state.categoryFilter)
            
            ForEach(Category.allCases, id: \ .id) { category in
                roundCategoryView(title: category.rawValue, image: category.image, foregroundColor: .white, backgroundColor: isSelected(category.id) ? .appGold : .clear, strokeColor: AppColor.gray, strokeLineWidth: 0.5) {
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
