//
//  Comment.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct Comment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: User
}
