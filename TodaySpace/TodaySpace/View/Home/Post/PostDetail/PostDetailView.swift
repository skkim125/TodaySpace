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
        Text("\(store.post.content)")

    }
}
