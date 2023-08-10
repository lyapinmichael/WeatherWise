//
//  Date+DayBefore.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 13.07.2023.
//

import Foundation

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var weekAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 6, to: self)!
    }
    
    static func from(iso8601String: String, utcOffsetSeconds: Int) -> Self? {
        let iso8601Formatter = ISO8601DateFormatter(with: [.withFullDate, .withDashSeparatorInDate, .withTime, .withColonSeparatorInTime, .withTimeZone] )
        let hours = utcOffsetSeconds / 3600
        let minutes = abs(utcOffsetSeconds / 60) % 60
        let utcOffset = String(format: "%+02d:%.2d", hours, minutes)
        let dateString = iso8601String + ":00" + utcOffset
        return iso8601Formatter.date(from: dateString)
    }
    
    static func from(_ string: String) -> Self? {
        return DateFormatter().date(from: string)
        
    }
}
