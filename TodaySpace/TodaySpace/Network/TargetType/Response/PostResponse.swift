//
//  PostResponse.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct FetchPostResult: Decodable {
    let data: [PostResponse]
    let next_cursor: String
}

struct PostResponse: Decodable {
    let post_id: String
    let category: String
    let title: String
    let content: String
    let content1: String
    let createdAt: String
    let creator: User
    let files: [String]?
    let likes: [String]
    let likes2: [String]
    let buyers: [String]
    let hashTags: [String]
    let comments: [Comment]
    let geolocation: Geolocation
//    let distance: Double?
}

struct Geolocation: Decodable {
    let latitude: Double
    let longitude: Double
}
