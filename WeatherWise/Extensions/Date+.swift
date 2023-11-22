//
//  Date+DayBefore.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 13.07.2023.
//

import Foundation

extension Date {
    var dayAfter: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    var weekAfter: Date? {
        return Calendar.current.date(byAdding: .day, value: 6, to: self)
    }
    
    static func from(iso8601String: String, utcOffsetSeconds: Int) -> Self? {
        
        /// В строке ниже мне пришлось изменить инициализацию ISO8601DateFormatter(),
        /// потому что в какой-то момент проект просто перестал собираться, а
        /// компилятор стал выдавать ошибки, хотя я в этой части ничего не менял от предыдщуего комита,
        /// в котором все работало.
        
        let iso8601Formatter = ISO8601DateFormatter()
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
