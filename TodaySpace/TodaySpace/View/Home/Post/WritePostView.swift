//
//  WritePostView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/28/25.
//

import SwiftUI
import ComposableArchitecture

struct WritePostView: View {
    @Bindable var store: StoreOf<WritePostFeature>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("포스트 작성")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .tint(Color(uiColor: .label))
        }
    }
}
