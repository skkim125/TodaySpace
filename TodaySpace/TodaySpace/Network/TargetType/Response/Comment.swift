//
//  Comment.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct Comment: Decodable, Equatable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.comment_id == rhs.comment_id
    }
    
    let comment_id: String
    let content: String?
    let createdAt: String?
    let creator: User
}
