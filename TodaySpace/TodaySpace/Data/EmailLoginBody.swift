//
//  EmailLoginBody.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import Foundation

struct EmailLoginBody: Encodable {
    var email: String
    var password: String
}
