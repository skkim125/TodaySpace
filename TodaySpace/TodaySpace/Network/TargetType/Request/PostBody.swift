//
//  PostBody.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct PostBody: Encodable {
    let title: String // 포스트 제목
    let content: String // 포스트 내용
    let category: String // 카테고리
    let files: [String] // 이미지
    let content1: String // 장소 이름
    let latitude: Double // 위도
    let longitude: Double // 경도
    let hashTags: [String]
}
