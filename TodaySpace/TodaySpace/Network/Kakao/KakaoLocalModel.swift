//
//  KakaoLocalModel.swift
//  TodaySpace
//
//  Created by 김상규 on 1/30/25.
//

import Foundation

struct Meta: Decodable {
    let total: Int // total_count
    let pageableCount: Int // pageable_count
    let isEnd: Bool // is_end
    
    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct PlaceInfo: Hashable, Decodable {
    let id: String
    let placeName: String // place_name
    let categoryName: String // category_name
    let categoryGroupName: String // category_group_name
    let address: String // address_name
    let roadAddress: String // road_address_name
    let lat: String // y
    let lon: String // x
    let placeURL: String // place_url
    var customCategory: String {
        if categoryGroupName.isEmpty {
            let parts = categoryName.components(separatedBy: ">")
            
            if parts.count == 2 {
                return parts.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? categoryName
            } else if parts.count >= 3 {
                return parts[parts.count - 2].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                return categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } else {
            return categoryGroupName
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "place_name"
        case categoryName = "category_name"
        case address = "address_name"
        case roadAddress = "road_address_name"
        case lat = "y"
        case lon = "x"
        case placeURL = "place_url"
        case categoryGroupName = "category_group_name"
    }
}
