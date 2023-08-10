//
//  HourlyTemperature.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 20.07.2023.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hourlyTemperature = try? JSONDecoder().decode(HourlyTemperature.self, from: jsonData)

import Foundation

// MARK: - Model to be used in presentation layer

struct HourlyTemperatureModel {
    let latitude, longitue: Double
    let timezone, timezoneAbbreviation: String
    let weathercode: [Int]
    let temperature: [Double]
    var time: [Date] = []
    
    private let utcOffestSeconds: Int
   
    init(from codableHourlyTemperature: HourlyTemperature) {
        self.latitude = codableHourlyTemperature.latitude
        self.longitue = codableHourlyTemperature.longitude
        self.timezone = codableHourlyTemperature.timezone
        self.timezoneAbbreviation = codableHourlyTemperature.timezoneAbbreviation
        self.weathercode = codableHourlyTemperature.hourly.weathercode
        self.temperature = codableHourlyTemperature.hourly.temperature2M
        self.utcOffestSeconds = codableHourlyTemperature.utcOffsetSeconds
        
        for timeString in codableHourlyTemperature.hourly.time {
            if let date = Date.from(iso8601String: timeString, utcOffsetSeconds: codableHourlyTemperature.utcOffsetSeconds) {
                self.time.append(date)
            }
        }
        
    }
}

// MARK: - HourlyTemperature
struct HourlyTemperature: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let hourlyUnits: HourlyUnits
    let hourly: Hourly

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let time: [String]
    let temperature2M: [Double]
    let weathercode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case weathercode
    }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
    let time, temperature2M, weathercode: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case weathercode
    }
}

extension ISO8601DateFormatter {
    convenience init(with formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
