//
//  AirQualityIndex.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 11.09.2023.
//

import Foundation
import UIKit


struct AirQualityIndexModel {

    private let hourlyAirQualityIndex: [Int]
    var averageHourlyIndex: Int {
        averageValue(of: hourlyAirQualityIndex)
    }
    
    var airQuality: (summary: String, color: UIColor, description: String) {
        switch averageHourlyIndex {
        case 0 ..< 10:
            return ("хорошо", UIColor.green, "Качество воздуха хорошее и не представляет угрозы для здоровья.")
        case 10 ..< 20:
            return ("нормально", UIColor.systemTeal, "Приемлемое качество. Некоторые люди могут испытывать дискомфорт.")
        case 20 ..< 25:
            return ("средне", UIColor.yellow, "Качество воздуха в этом диапазоне вредно для чувствительных групп. Они испытывают дискомфорт при дыхании.")
        case 25 ..< 50:
            return ("плохо", UIColor.orange, "Нездоровое качество воздуха, и люди начинают испытывать такие эффекты, как затрудненное дыхание.")
        case 50 ..< 75:
            return ("очень плохо", UIColor.red, "Качество воздуха в этом диапазоне очень нездоровое, и в случае чрезвычайных ситуаций могут быть выданы предупреждения о вреде для здоровья. Все люди, вероятно, будут затронуты.")
        case 75 ..< 100:
            return ("ужасно", UIColor.brown, "Это опасная категория качества воздуха, и все могут испытывать серьезные последствия для здоровья, такие как дискомфорт при дыхании, удушье, раздражение дыхательных путей и т. д.")
        default:
            return ("ошибка", UIColor.systemGray, "Не удалось определить качество воздуха.")
        }
    }
    
    // MARK: Init
    
    init(from decodedAirQualityIndex: AirQualityIndex) {
        self.hourlyAirQualityIndex = decodedAirQualityIndex.hourly.europeanAqi
    }
    
    //MARK: Private methods
    
    private func averageValue(of intArray: [Int]) -> Int {
        let lenght = intArray.count
        let sum = intArray.reduce(0, +)
        
        return sum / lenght
        
    }
    
}

// MARK: - AirQualityIndex
struct AirQualityIndex: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let hourlyUnits: HourlyAQIUnits
    let hourly: HourlyAQI

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case hourlyUnits = "hourly_units"
        case hourly
    }
}

// MARK: - Hourly
struct HourlyAQI: Codable {
    let time: [String]
    let europeanAqi: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case europeanAqi = "european_aqi"
    }
}

// MARK: - HourlyUnits
struct HourlyAQIUnits: Codable {
    let time, europeanAqi: String

    enum CodingKeys: String, CodingKey {
        case time
        case europeanAqi = "european_aqi"
    }
}

