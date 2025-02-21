//
//  PostDetailView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI
import ComposableArchitecture

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<PostDetailFeature>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(store.post.title)
                    .font(.title).bold()
                    .padding(.leading)
                Text(store.post.content1)
                    .padding(.leading)
                Text(store.post.content2)
                    .padding(.leading)
                
                imageListView()
                
                Text(store.post.content)
                    .padding(.leading)
                
                VStack {
                    Text("댓글: \(store.post.comments.count)개")
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                }
            }
            
            VStack {
                if store.post.comments.isEmpty {
                    Text("첫 댓글을 작성해보세요!")
                        .padding(.top, 20)
                } else {
                    ForEach(store.mockComment, id: \.comment_id) { comment in
                        CommentView(comment: comment)
                    }
                }
            }
            .padding(.horizontal, 5)
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(AppColor.appBackground)
        .customNavigationBar {
            EmptyView()
        } leftView: {
            Button {
                dismiss()
            } label: {
                Label {
                    Text("뒤로")
                } icon: {
                    Image(systemName: "chevron.backward")
                }
            }
        } rightView: {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func imageListView() -> some View {
        if let images = store.post.files {
            if images.count == 1 {
                ImageView(imageURL: images[0], frame: .auto)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<images.count, id: \.self) { index in
                            ImageView(imageURL: images[index], frame: .setFrame(UIScreen.main.bounds.width - 100, 300))
                                .overlay {
                                    VStack(alignment: .center) {
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Circle()
                                                .fill(AppColor.black)
                                                .overlay {
                                                    Text("\(index + 1)")
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(AppColor.white)
                                                        .multilineTextAlignment(.center)
                                                }
                                                .frame(width: 25, height: 25)
                                        }
                                        .padding(10)
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
}
