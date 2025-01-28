//
//  TokenResponse.swift
//  TodaySpace
//
//  Created by 김상규 on 1/28/25.
//

import Foundation

struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
