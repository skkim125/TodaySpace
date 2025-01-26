//
//  ErrorType.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

struct ErrorType: Decodable, Error {
    let message: String
}
