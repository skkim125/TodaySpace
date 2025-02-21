//
//  PostDetailFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct PostDetailFeature: Reducer {
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.postClient) var postClient
    
    @ObservableState
    struct State {
        var post: PostResponse
        var mockComment: [Comment] = [] // [
//            Comment(comment_id: "1231223", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "123122512", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "123122612", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "123127312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "123182312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "123922312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "1222312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "43122312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "223122312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "143122312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "12312231", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")),
//            Comment(comment_id: "123122", content: "오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. 오 여기 좋더라구요. ", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: ""))
//        ]
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
