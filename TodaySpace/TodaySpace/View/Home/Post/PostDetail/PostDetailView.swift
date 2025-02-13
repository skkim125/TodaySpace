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
            Text(store.post.title)
            
            if let images = store.post.files {
                if images.count == 1 {
                    ImageView(imageURL: images[0], frame: .auto)
                        .padding(.horizontal)
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<5, id: \.self) { index in
                                ImageView(imageURL: images[0], frame: .setFrame(UIScreen.main.bounds.width - 100, 300))
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
        }
    }
}
