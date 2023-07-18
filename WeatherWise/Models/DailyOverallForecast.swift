// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dailyOverallForecast = try? JSONDecoder().decode(DailyOverallForecast.self, from: jsonData)

import Foundation

// MARK: - DailyOverallForecast
struct DailyOverallForecast: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let hourlyUnits: HourlyOverallUnits
    let hourly: HourlyOverall
    let dailyUnits: DailyOverallUnits
    let daily: DailyOverall
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
    }
}

// MARK: - Daily
struct DailyOverall: Codable {
    let time: [String]
    let temperature2MMax: [Double]
    let temperature2MMin: [Double]
    let sunrise, sunset: [String]
    let precipitationProbabilityMax: [Int]
    let uvIndexMax: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case sunrise, sunset
        case precipitationProbabilityMax = "precipitation_probability_max"
        case uvIndexMax = "uv_index_max"
    }
}

// MARK: - DailyUnits
struct DailyOverallUnits: Codable {
    let time, temperature2MMax, temperature2MMin, sunrise: String
    let sunset, uvIndexMax, precipitationProbabilityMax, windspeed10MMax: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case sunrise, sunset
        case uvIndexMax = "uv_index_max"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case windspeed10MMax = "windspeed_10m_max"
    }
}

// MARK: - Hourly
struct HourlyOverall: Codable {
    let time: [String]
    let temperature2M: [Double]
    let weathercode: [Int]
    let windspeed10M: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case weathercode
        case windspeed10M = "windspeed_10m"
    }
}

// MARK: - HourlyUnits
struct HourlyOverallUnits: Codable {
    let time, temperature2M, weathercode, windspeed10M: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case weathercode
        case windspeed10M = "windspeed_10m"
    }
}
