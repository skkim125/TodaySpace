//
//  ImageUploadBody.swift
//  TodaySpace
//
//  Created by 김상규 on 2/1/25.
//

import Foundation

struct ImageUploadBody {
   let boundary: String = UUID().uuidString
   let files: [Data]
}
