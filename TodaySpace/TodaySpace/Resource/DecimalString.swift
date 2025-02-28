//
//  DecimalString.swift
//  TodaySpace
//
//  Created by 김상규 on 2/28/25.
//

import Foundation

protocol DecimalString {
    var decimalValue: NSNumber { get }
}

extension DecimalString {
    var decimalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedStr = formatter.string(from: decimalValue) {
            return formattedStr
        } else {
            return ""
        }
    }
}
