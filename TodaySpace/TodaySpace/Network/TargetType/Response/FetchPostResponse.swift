//
//  FetchPostResponse.swift
//  TodaySpace
//
//  Created by 김상규 on 2/15/25.
//

import Foundation

struct FetchPostResponse: Decodable {
    let data: [PostResponse]
    let next_cursor: String
}
