//
//  DateFormatter+.swift
//  TodaySpace
//
//  Created by 김상규 on 2/21/25.
//

import Foundation

enum DateFormatType {
    case relative
    case formatted
}

extension DateFormatter {
    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 3600)
        return formatter
    }()
    
    static let yearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }()
    
    private static let noneYearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    static func convertDateString(_ dateString: String, type: DateFormatType) -> String {
        guard let postDate = iso8601Formatter.date(from: dateString) else {
            return "잘못된 날짜 형식입니다."
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        switch type {
        case .relative:
            let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: postDate, to: now)
            
            if let year = components.year, year > 0 {
                return "\(year)년 전"
            } else if let month = components.month, month > 0 {
                return "\(month)개월 전"
            } else if let week = components.weekOfYear, week > 0 {
                return "\(week)주 전"
            } else if let day = components.day, day > 0 {
                return "\(day)일 전"
            } else if let hour = components.hour, hour > 0 {
                return "\(hour)시간 전"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)분 전"
            } else {
                return "방금 전"
            }
            
        case .formatted:
            let components = calendar.dateComponents([.year], from: postDate, to: now)
            let formatter: DateFormatter = (components.year ?? 0) >= 1 ? yearDateFormatter : noneYearDateFormatter
            return formatter.string(from: postDate)
        }
    }
}
