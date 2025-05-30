//
//  PostResponse.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct PostResponse: Decodable {
    let post_id: String // 게시물 id
    let category: String // 카테고리
    let title: String // 게시물명
    let content: String // 게시물 설명
    let content1: String // 장소명
    let content2: String // 장소 주소
    let content3: String // 장소 url
    let content4: String // 장소 방문 날짜
    let createdAt: String // 생성날짜
    let creator: User // 게시물 작성 유저
    let files: [String] // 이미지
    let likes: [String] // 좋아요
    let likes2: [String]
    let buyers: [String] // 구매자
    let hashTags: [String] // 검색용 해시태그
    let comments: [Comment] // 댓글
    let geolocation: Geolocation // 위치
    let distance: Double? // 현재 위치로부터의 거리
}

struct Geolocation: Decodable {
    let latitude: Double
    let longitude: Double
}
