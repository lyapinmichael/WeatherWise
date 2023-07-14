// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherForecast = try? JSONDecoder().decode(WeatherForecast.self, from: jsonData)

import Foundation

// To be depricated and deleted

// MARK: - WeatherForecast
struct WeatherForecast: Codable {
    let type: String
    let geometry: Geometry
    let properties: Properties
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - Properties
struct Properties: Codable {
    let meta: Meta
    let timeseries: [Timesery]
}

// MARK: - Meta
struct Meta: Codable {
    let updatedAt: String
    let units: Units

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case units
    }
}

// MARK: - Units
struct Units: Codable {
    let  airTemperature: Double
    let airPressureAtSeaLevel, cloudAreaFraction, precipitationAmount: String
    let relativeHumidity, windFromDirection, windSpeed: String

    enum CodingKeys: String, CodingKey {
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"
        case airTemperature = "air_temperature"
        case cloudAreaFraction = "cloud_area_fraction"
        case precipitationAmount = "precipitation_amount"
        case relativeHumidity = "relative_humidity"
        case windFromDirection = "wind_from_direction"
        case windSpeed = "wind_speed"
    }
}

// MARK: - Timesery
struct Timesery: Codable {
    let time: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let instant: Instant
    let next12_Hours: Next12_Hours?
    let next1_Hours, next6_Hours: NextHours?

    enum CodingKeys: String, CodingKey {
        case instant
        case next12_Hours = "next_12_hours"
        case next1_Hours = "next_1_hours"
        case next6_Hours = "next_6_hours"
    }
}

// MARK: - Instant
struct Instant: Codable {
    let details: InstantDetails
}

// MARK: - InstantDetails
struct InstantDetails: Codable {
    let airPressureAtSeaLevel, airTemperature, cloudAreaFraction, relativeHumidity: Double
    let windFromDirection, windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"
        case airTemperature = "air_temperature"
        case cloudAreaFraction = "cloud_area_fraction"
        case relativeHumidity = "relative_humidity"
        case windFromDirection = "wind_from_direction"
        case windSpeed = "wind_speed"
    }
}

// MARK: - Next12_Hours
struct Next12_Hours: Codable {
    let summary: Summary
}

// MARK: - Summary
struct Summary: Codable {
    let symbolCode: String

    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

enum SymbolCode: String, Codable {
    case clearskyDay = "clearsky_day"
    case clearskyNight = "clearsky_night"
    case fairDay = "fair_day"
    case partlycloudyDay = "partlycloudy_day"
}

// MARK: - NextHours
struct NextHours: Codable {
    let summary: Summary
    let details: Next1_HoursDetails
}

// MARK: - Next1_HoursDetails
struct Next1_HoursDetails: Codable {
    let precipitationAmount: Int

    enum CodingKeys: String, CodingKey {
        case precipitationAmount = "precipitation_amount"
    }
}
