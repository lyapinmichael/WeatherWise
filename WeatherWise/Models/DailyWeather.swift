//
//  DailyAverageTemerature.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 12.07.2023.
//

import Foundation

struct DailyWeather {
    let date: Date
    var temperatures: [Double] {
        didSet {
            temperatures.sort(by: <)
        }
    }
}
