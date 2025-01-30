//
//  KakaoLocalQuery.swift
//  TodaySpace
//
//  Created by 김상규 on 1/30/25.
//

import Foundation

struct KakaoLocalQuery: Encodable {
    let sort = "accuracy"
    let query: String
    let page: Int = 1
    var size: Int = 15
}
