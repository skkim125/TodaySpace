//
//  PlaceResponse.swift
//  TodaySpace
//
//  Created by 김상규 on 1/30/25.
//

import Foundation

struct PlaceResponse: Decodable {
    let meta: Meta
    let results: [PlaceInfo]
    
    enum CodingKeys: String, CodingKey {
        case meta
        case results = "documents"
    }
}
