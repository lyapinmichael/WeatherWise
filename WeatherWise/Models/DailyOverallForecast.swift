// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dailyOverallForecast = try? JSONDecoder().decode(DailyOverallForecast.self, from: jsonData)

import Foundation

// MARK: - Model to be used in presentation layer

struct DailyOverallForecastModel {
    let timezone: TimeZone?
    let sunrise, sunset: Date
    
    private let _hourlyTemperature: [Double]
    var hourlyTemperature: [Double] {
        if UserDefaults.standard.integer(forKey: "temperatureUnit") == 1 {
            return _hourlyTemperature.map { $0 * 9 / 5 + 32 }
        } else {
            return _hourlyTemperature
        }
    }
    
    private let _maxTemperature: Double
    var maxTemperature: Double {
        if UserDefaults.standard.integer(forKey: "temperatureUnit") == 1 {
            return _maxTemperature * 9 / 5 + 32
        } else {
            return _maxTemperature
        }
    }

    private let _minTemperature: Double
    var minTemperature: Double {
        if UserDefaults.standard.integer(forKey: "temperatureUnit") == 1 {
            return _maxTemperature * 9 / 5 + 32
        } else {
            return _maxTemperature
        }
    }
    
    private let _hourlyWindspeed: [Double]
    var hourlyWindspeed: [Double] {
        if UserDefaults.standard.integer(forKey: "speedUnit") == 1 {
            return _hourlyWindspeed.map { $0 * 0.5144 }
        } else {
            return _hourlyWindspeed
        }
    }
    
    var speedUnit: String {
        if UserDefaults.standard.integer(forKey: "speedUnit") == 1 {
            return "уз"
        } else {
            return "м/с"
        }
    }
            
    let maxUVindex: Double
    let hourlyWeatherCode: [Int]
    let maxPrecipitationProbability: Int
    
    init(from codableDailyOverallForecast: DailyOverallForecast) {
        self.timezone = TimeZone(secondsFromGMT: codableDailyOverallForecast.utcOffsetSeconds)
        self.sunrise = Date.from(iso8601String: codableDailyOverallForecast.daily.sunrise.first ?? "1998.08.04T00:00", utcOffsetSeconds: codableDailyOverallForecast.utcOffsetSeconds) ?? Date()
        self.sunset = Date.from(iso8601String: codableDailyOverallForecast.daily.sunset.first ?? "1998.08.04T00:00", utcOffsetSeconds: codableDailyOverallForecast.utcOffsetSeconds) ?? Date()
        self._hourlyTemperature = codableDailyOverallForecast.hourly.temperature2M
        self._maxTemperature = codableDailyOverallForecast.daily.temperature2MMax.first ?? 0.0
        self._minTemperature = codableDailyOverallForecast.daily.temperature2MMin.first ?? 0.0
        self._hourlyWindspeed = codableDailyOverallForecast.hourly.windspeed10M
        self.hourlyWeatherCode = codableDailyOverallForecast.hourly.weathercode
        self.maxPrecipitationProbability = codableDailyOverallForecast.daily.precipitationProbabilityMax.first ?? 0
        self.maxUVindex = codableDailyOverallForecast.daily.uvIndexMax.first ?? 0.0
    }
}

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
