//
//  User.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct User: Decodable {
    let user_id: String?
    let nick: String?
    let profileImage: String?
    
    init(user_Id: String? = nil, nick: String? = nil, profileImage: String? = nil) {
        self.user_id = user_Id
        self.nick = nick
        self.profileImage = profileImage
    }
}
