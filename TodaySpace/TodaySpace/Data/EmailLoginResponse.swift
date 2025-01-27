//
//  EmailLoginResponse.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import Foundation

struct EmailLoginResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
