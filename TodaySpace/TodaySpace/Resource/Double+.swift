//
//  Double+.swift
//  TodaySpace
//
//  Created by 김상규 on 2/28/25.
//

import Foundation

extension Double: DecimalString {
    var decimalValue: NSNumber { return NSNumber(value: self) }
}
