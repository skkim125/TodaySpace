//
//  PostDetailView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI
import ComposableArchitecture

struct PostDetailView: View {
    @Bindable var store: StoreOf<PostDetailFeature>
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            if store.isLoading {
                ProgressView()
            }
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(store.title)
                            .font(.title).bold()
                            .padding(.leading)
                        Text(store.placeName)
                            .padding(.leading)
                        Text(store.placeAddress)
                            .padding(.leading)
                        
                        imageListView()
                        
                        Text(store.content)
                            .padding(.leading)
                        
                        VStack {
                            HStack(alignment: .bottom) {
                                Image(systemName: "text.bubble.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                
                                Text("댓글 \(store.comments.count)개")
                                    .font(.title2)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.leading)
                        }
                    }
                    
                    VStack {
                        if store.comments.isEmpty {
                            Text("첫 댓글을 작성해보세요!")
                                .padding(.vertical, 20)
                        } else {
                            ForEach(store.comments, id: \.comment_id) { comment in
                                CommentView(postCreatorID: store.postCreatorID, comment: comment)
                                    .id(comment.comment_id)
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .onChange(of: store.comments) { oldValue, newValue in
                    if !oldValue.isEmpty {
                        if let lastComment = newValue.last {
                            proxy.scrollTo(lastComment.comment_id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(AppColor.appBackground)
        .customNavigationBar {
            EmptyView()
        } leftView: {
            Button {
                store.send(.dismiss)
            } label: {
                Label {
                    Text("뒤로")
                } icon: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
        } rightView: {
            HStack(spacing: 20) {
                Button {
                    store.send(.toggleLiked)
                } label: {
                    Image(systemName: store.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.orange)
                        .frame(width: 25, height: 25)
                }
                
                Button {
                    print("info.circle.fill")
                } label: {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            commentInputView()
        }
        .onAppear {
            store.send(.viewAppear)
        }
    }
    
    @ViewBuilder
    private func commentInputView() -> some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack {
                TextField("댓글을 입력하세요", text: $store.commentText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .focused($isFocused)
                
                if !store.commentText.isEmpty {
                    Button {
                        isFocused = false
                        store.send(.commentButtonTap)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white, store.commentText.isEmpty ? AppColor.gray : .orange)
                            .clipShape(Circle())
                            .frame(width: 28, height: 28)
                    }
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            .animation(.easeInOut, value: store.commentText)
        }
        .background(AppColor.appBackground)
    }
    
    @ViewBuilder
    private func imageListView() -> some View {
        if store.images.count == 1 {
            ImageView(imageURL: store.images[0], frame: .auto)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.horizontal)
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<store.images.count, id: \.self) { index in
                        ImageView(imageURL: store.images[index], frame: .setFrame(UIScreen.main.bounds.width - 100, 300))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6).stroke(AppColor.grayStroke, lineWidth: 1)
                                    VStack(alignment: .center) {
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Circle()
                                                .fill(AppColor.black)
                                                .overlay {
                                                    Text("\(index + 1)")
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(AppColor.white)
                                                        .multilineTextAlignment(.center)
                                                }
                                                .frame(width: 25, height: 25)
                                        }
                                        .padding(10)
                                    }
                                }
                            }
                            .padding(.leading, index == 0 ? 20 : 0)
                            .padding(.horizontal, index != 0 && index != 4 ? 10 : 0)
                            .padding(.trailing, index == 4 ? 20 : 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
