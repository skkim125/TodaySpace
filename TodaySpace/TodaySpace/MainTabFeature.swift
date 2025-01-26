//
//  MainTabFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum TabInfo: String {
    case home = "홈"
    case search = "검색"
    case dm = "DM"
    case myPage = "마이페이지"
    
    var image: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .dm:
            return "message"
        case .myPage:
            return "person.crop.circle"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .search:
            return "magnifyingglass"
        case .dm:
            return "message.fill"
        case .myPage:
            return "person.crop.circle.fill"
        }
    }
}
