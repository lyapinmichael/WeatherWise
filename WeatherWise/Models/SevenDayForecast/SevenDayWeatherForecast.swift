// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sevenDayWeahterForecast = try? JSONDecoder().decode(SevenDayWeahterForecast.self, from: jsonData)

import Foundation

// MARK: - Model to be used in presentation layer

final public class SevenDayWeatherForecastModel: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    // MARK: - Encode method
    public func encode(with coder: NSCoder) {
        coder.encode(time as Any?, forKey: "time")
        coder.encode(weatherCode as Any?, forKey: "weatherCode")
        coder.encode(maxPrecipitationProbabily as Any?, forKey: "maxPrecipitationProbability")
        coder.encode(_maxTemperature as Any?, forKey: "_maxTemperature")
        coder.encode(_minTemperature as Any?, forKey: "_minTemperature")
    }
    
    let time: [Date]
    let weatherCode, maxPrecipitationProbabily: [Int]
    
    private var _maxTemperature: [Double] = []
    var maxTemperature: [Double] {
        if UserDefaults.standard.integer(forKey: "temperatureUnit") == 1 {
            return _maxTemperature.map { $0 * 9 / 5 + 32 }
        } else {
            return _maxTemperature
        }
    }
    
    private var _minTemperature: [Double]
    var minTemperature: [Double] {
        if UserDefaults.standard.integer(forKey: "temperatureUnit") == 1 {
            return _minTemperature.map { $0 * 9 / 5 + 32 }
        } else {
            return _minTemperature
        }
    }
    
    // MARK: - Init
    
    init(from decodedSevenWeahterForecast: SevenDayWeahterForecast) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let timeArray = decodedSevenWeahterForecast.daily.time
        self.time = timeArray.map({ dateFormatter.date(from: $0) ?? Date()})
        self.weatherCode = decodedSevenWeahterForecast.daily.weathercode
        self.maxPrecipitationProbabily = decodedSevenWeahterForecast.daily.precipitationProbabilityMax.map({ $0 ?? 0})
        self._maxTemperature = decodedSevenWeahterForecast.daily.temperature2MMax
        self._minTemperature = decodedSevenWeahterForecast.daily.temperature2MMin
      
    }
    
    // MARK: - Init from coder
    
    public init?(coder: NSCoder) {
        time = coder.decodeObject(forKey: "time") as? [Date] ?? []
        weatherCode = coder.decodeObject(forKey: "weatherCode") as? [Int] ?? []
        maxPrecipitationProbabily = coder.decodeObject(forKey: "maxPrecipitationProbability") as? [Int] ?? []
        _maxTemperature = coder.decodeObject(forKey: "_maxTemperature") as? [Double] ?? []
        _minTemperature = coder.decodeObject(forKey: "_minTemperature") as? [Double] ?? []
        
    }
    
}



// MARK: - SevenDayWeahterForecast
struct SevenDayWeahterForecast: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let dailyUnits: DailyUnits
    let daily: Daily

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case dailyUnits = "daily_units"
        case daily
    }
}

// MARK: - Daily
struct Daily: Codable {
    let time: [String]
    let weathercode: [Int]
    let temperature2MMax, temperature2MMin: [Double]
    let precipitationProbabilityMax: [Int?]

    enum CodingKeys: String, CodingKey {
        case time, weathercode
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
    }
}

// MARK: - DailyUnits
struct DailyUnits: Codable {
    let time, weathercode, temperature2MMax, temperature2MMin: String
    let precipitationProbabilityMax: String

    enum CodingKeys: String, CodingKey {
        case time, weathercode
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
    }
}
