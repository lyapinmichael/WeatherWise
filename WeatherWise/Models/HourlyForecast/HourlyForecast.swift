//
//  HourlyTemperature.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 20.07.2023.
//

import Foundation


// MARK: - Model to be used in presentation layer

final public class HourlyForecastModel: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    
    // MARK: - Enocde method
    public func encode(with coder: NSCoder) {
        coder.encode(latitude as Any?, forKey: "latitude")
        coder.encode(longitue as Any?, forKey: "longitue")
        coder.encode(timezone as Any?, forKey: "timezone")
        coder.encode(timezoneAbbreviation as Any?, forKey: "timezoneAbbreviation")
        coder.encode(weathercode as Any?, forKey: "weathercode")
        coder.encode(precipitationProbability as Any?, forKey: "precipitationProbability")
        coder.encode(cloudcover as Any?, forKey: "cloudcover")
        coder.encode(windspeed as Any?, forKey: "windspeed")
        coder.encode(_temperature as Any?, forKey: "_temperature")
        coder.encode(_windDirection as Any?, forKey: "_windDirection")
        coder.encode(_time as Any?, forKey: "_time")
        coder.encode(utcOffestSeconds as Any?, forKey: "utcOffestSeconds")
    }
    
    let latitude, longitue: Double
    let timezone, timezoneAbbreviation: String
    let weathercode, precipitationProbability, cloudcover: [Int]
    let windspeed: [Double]
    
    private let _temperature: [Double]
    var temperature: [Double] {
        if UserDefaults.standard.integer(forKey: "temperatureUnit") == 1 {
            return _temperature.map { $0 * 9 / 5 + 32 }
        } else {
            return _temperature
        }
    }
    
    private var _windDirection: [Int]
    var windDirection: [String] {
        return _windDirection.map {
            WWWindDirectionAngleDecoder.decode(angle: $0)
        }
    }
    
    var speedUnit: String {
        if UserDefaults.standard.integer(forKey: "speedUnit") == 1 {
            return "уз"
        } else {
            return "м/с"
        }
    }
    
    private var _time: [Date] = []
    var time: [String] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        
        if UserDefaults.standard.integer(forKey: "timeFormat") == 1 {
            dateFormatter.dateFormat = "h a"
        } else {
            dateFormatter.dateFormat = "HH:00"
        }
        
        return _time.map { dateFormatter.string(from: $0) }
    }
    
    var timeFormat: String {
        if UserDefaults.standard.integer(forKey: "timeFormat") == 1 {
            return "h a"
        } else {
            return "HH:00"
        }
    }
    
    private let utcOffestSeconds: Int
    
    // MARK: - Init
   
    init(from codableHourlyTemperature: HourlyTemperature) {
        self.latitude = codableHourlyTemperature.latitude
        self.longitue = codableHourlyTemperature.longitude
        self.timezone = codableHourlyTemperature.timezone
        self.timezoneAbbreviation = codableHourlyTemperature.timezoneAbbreviation
        self.weathercode = codableHourlyTemperature.hourly.weathercode
        self._temperature = codableHourlyTemperature.hourly.temperature2M
        self.precipitationProbability = codableHourlyTemperature.hourly.precipitationProbability
        self.cloudcover = codableHourlyTemperature.hourly.cloudcover
        self.windspeed = codableHourlyTemperature.hourly.windspeed10M
        self._windDirection = codableHourlyTemperature.hourly.winddirection10M
        
        self.utcOffestSeconds = codableHourlyTemperature.utcOffsetSeconds
        
        
        for timeString in codableHourlyTemperature.hourly.time {
            if let date = Date.from(iso8601String: timeString, utcOffsetSeconds: codableHourlyTemperature.utcOffsetSeconds) {
                self._time.append(date)
            }
        }
        
    }
    
    // MARK: - Init from coder
    
    public init?(coder: NSCoder) {
        latitude = coder.decodeObject(forKey: "latitude") as? Double ?? 0.0
        longitue = coder.decodeObject(forKey: "longitude") as? Double ?? 0.0
        timezone = coder.decodeObject(forKey: "timezone") as? String ?? "Europe/Moscow"
        timezoneAbbreviation = coder.decodeObject(forKey: "timezoneAbbreviation") as? String ?? "MSK"
        weathercode = coder.decodeObject(forKey: "weathercode") as? [Int] ?? []
        precipitationProbability = coder.decodeObject(forKey: "precipitationProbability") as? [Int] ?? []
        cloudcover = coder.decodeObject(forKey: "cloudcover") as? [Int] ?? []
        windspeed = coder.decodeObject(forKey: "windspeed") as? [Double] ?? []
        _temperature = coder.decodeObject(forKey: "_temperature") as? [Double] ?? []
        _windDirection = coder.decodeObject(forKey: "_windDirection") as? [Int] ?? []
        _time = coder.decodeObject(forKey: "_time") as? [Date] ?? []
        utcOffestSeconds = coder.decodeObject(forKey: "utcOffestSeconds") as? Int ?? 0
        
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
    let precipitationProbability, weathercode, cloudcover: [Int]
    let windspeed10M: [Double]
    let winddirection10M: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case precipitationProbability = "precipitation_probability"
        case weathercode, cloudcover
        case windspeed10M = "windspeed_10m"
        case winddirection10M = "winddirection_10m"
    }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
    let time, temperature2M, precipitationProbability, weathercode: String
    let cloudcover, windspeed10M, winddirection10M: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case precipitationProbability = "precipitation_probability"
        case weathercode, cloudcover
        case windspeed10M = "windspeed_10m"
        case winddirection10M = "winddirection_10m"
    }
}
