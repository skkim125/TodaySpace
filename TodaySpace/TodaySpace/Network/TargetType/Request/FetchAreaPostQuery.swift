//
//  FetchAreaPostQuery.swift
//  TodaySpace
//
//  Created by 김상규 on 2/15/25.
//

import MapKit

struct FetchAreaPostQuery: Encodable {
    let category: [String]
    let latitude: String
    let longitude: String
    
    init(category: [String] = [], lat: CLLocationDegrees, lon: CLLocationDegrees) {
        self.category = category
        self.latitude = String(lat)
        self.longitude = String(lon)
    }
}
