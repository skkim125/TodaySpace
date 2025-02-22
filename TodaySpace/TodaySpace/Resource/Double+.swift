//
//  Double+.swift
//  TodaySpace
//
//  Created by 김상규 on 2/22/25.
//

import Foundation

extension Double {
    var decimalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let distanceStr = formatter.string(from: NSNumber(value: Int(self))) {
            return distanceStr + "m"
        } else {
            return ""
        }
    }
}
