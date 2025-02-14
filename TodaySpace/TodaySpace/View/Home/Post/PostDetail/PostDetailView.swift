//
//  PostDetailView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI
import ComposableArchitecture

struct PostDetailView: View {
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
                
                if let images = store.post.files {
                    if images.count == 1 {
                        ImageView(imageURL: images[0], frame: .auto)
                            .padding(.horizontal)
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<images.count, id: \.self) { index in
                                    ImageView(imageURL: images[index], frame: .setFrame(UIScreen.main.bounds.width - 100, 300))
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
                
                Text(store.post.content)
                    .padding(.leading)
            }
            .padding(.top, 10)
        }
        .onAppear {
            print(store.post)
        }
    }
}
