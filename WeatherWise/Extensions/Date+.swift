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
}
