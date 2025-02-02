//
//  FetchPostQuery.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct FetchPostQuery: Encodable {
    let next: String
    let limit: String
    let category: [String]
    
    init(next: String = "", limit: String = "10", category: [String] = []) {
        self.next = next
        self.limit = limit
        self.category = category
    }
}
