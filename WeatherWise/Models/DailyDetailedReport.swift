//
//  DailyDetailedReport.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 11.09.2023.
//

import Foundation

//MARK: - View layer model
struct DailyDetailedReportModel {
    
    // MARK: Day info properties
    let maxPrecipitationProbabilityDay: Int
    
    let maxUVIndexDay: Double

    private let _maxWindSpeedDay: Double
    var maxWindSpeedDate: Double {
        checkWindSpeedUnit(_maxWindSpeedDay)
    }
    
    private let _maxTemperatureDay: Double
    var maxTemperatureDay: Double {
        checkTemperatureUnit(_maxTemperatureDay)
    }
    
    private let _maxApparentTemperatureDay: Double
    var maxApparentTemperatureDay: Double {
        checkTemperatureUnit(_maxApparentTemperatureDay)
    }
    
    private let cloudCoverDay: [Int]
    var averageCloudCoverDay: Int {
        averageValue(of: cloudCoverDay)
    }
    
    private let windDirectionsDay: [Int]
    var dominantWindDirectionDay: String {
        let windDirectionAngle = mostFrequentElement(of: windDirectionsDay)
        return WWWindDirectionAngleDecoder.decode(angle: windDirectionAngle)
    }
    
    private let weatherCodesDay: [Int]
    var dominantWeatherCodeDay: Int {
        mostFrequentElement(of: weatherCodesDay)
    }
    
    private let weatherCodesNight: [Int]
    var dominantWeatherCodeNight: Int {
        mostFrequentElement(of: weatherCodesNight)
    }
    
    // MARK: Night info properties
    let maxPrecipitationProbabilityNight: Int
    
    let maxUVIndexNight: Double
    
    private let _maxWindSpeedNight: Double
    var maxWindSpeedNight: Double {
        checkWindSpeedUnit(_maxWindSpeedNight)
    }
   
    private let _maxTemperatureNight: Double
    var maxTemperatureNight: Double {
        checkTemperatureUnit(_maxTemperatureNight)
    }
    
    private let _maxApparentTemperatureNight: Double
    var maxApparentTemperatureNight: Double {
        checkTemperatureUnit(_maxApparentTemperatureNight)
    }
    
    private let cloudCoverNight: [Int]
    var  averageCloudCoverNight: Int {
        averageValue(of: cloudCoverNight)
    }
    
    private let windDirectionsNight: [Int]
    var domninantWindDirectionNight: String {
        let windDirectionAngle = mostFrequentElement(of: windDirectionsNight)
        return WWWindDirectionAngleDecoder.decode(angle: windDirectionAngle)
    }
    
    // MARK: Common properties
    
    var speedUnit: String {
        if UserDefaults.standard.integer(forKey: "speedUnit") == 1 {
            return "уз"
        } else {
            return "м/с"
        }
    }
    
    private var dateFormatter: DateFormatter = DateFormatter()
    
    private let _sunrise: Date?
    var sunrise: String {
        guard let _sunrise = self._sunrise else { return "00:00"}
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: _sunrise)
    }
    
    private let _sunset: Date?
    var sunset: String {
        guard let _sunset = self._sunset else { return "00:00" }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: _sunset)
    }
    
    var solarDayLenght: String {
        guard let sunrise = _sunrise,
              let sunset = _sunset else { return "00:00" }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: sunrise, to: sunset)
        let hours = components.hour ?? 0
        let mintutes = components.minute ?? 0
        return String(hours) + ":" + String(mintutes)
    }
    
    // MARK: - Init
    
    init(from dailyDetailedReport: DailyDetailedReport) {
       
        var windSpeedsDay: [Double] = []
        var windSpeedsNight: [Double] = []
        
        var windDirectionsDay: [Int] = []
        var windDirectionsNight: [Int] = []
        
        var precipitationPrbabilitiesDay: [Int] = []
        var precipitationPrbabilitiesNight: [Int] = []
        
        var temperaturesDay: [Double] = []
        var temperaturesNight: [Double] = []
        
        var apparentTemperaturesDay: [Double] = []
        var apparentTemperaturesNight: [Double] = []
        
        var cloudCoverDay: [Int] = []
        var cloudCoverNight: [Int] = []
        
        var weatherCodesDay: [Int] = []
        var weatherCodesNight: [Int] = []
        
        var UVIndexDay: [Double] = []
        var UVIndexNight: [Double] = []
        
        for i in 0 ..< dailyDetailedReport.hourly.time.count {
            
            if dailyDetailedReport.hourly.isDay[i] == 1 {
                windSpeedsDay.append(dailyDetailedReport.hourly.windspeed10M[i])
                windDirectionsDay.append(dailyDetailedReport.hourly.winddirection10M[i])
                precipitationPrbabilitiesDay.append(dailyDetailedReport.hourly.precipitationProbability[i])
                temperaturesDay.append(dailyDetailedReport.hourly.temperature2M[i])
                apparentTemperaturesDay.append(dailyDetailedReport.hourly.apparentTemperature[i])
                cloudCoverDay.append(dailyDetailedReport.hourly.cloudcover[i])
                weatherCodesDay.append(dailyDetailedReport.hourly.weathercode[i])
                UVIndexDay.append(dailyDetailedReport.hourly.uvIndex[i])
                
            } else {
                windSpeedsNight.append(dailyDetailedReport.hourly.windspeed10M[i])
                windDirectionsNight.append(dailyDetailedReport.hourly.winddirection10M[i])
                precipitationPrbabilitiesNight.append(dailyDetailedReport.hourly.precipitationProbability[i])
                temperaturesNight.append(dailyDetailedReport.hourly.temperature2M[i])
                apparentTemperaturesNight.append(dailyDetailedReport.hourly.apparentTemperature[i])
                cloudCoverNight.append(dailyDetailedReport.hourly.cloudcover[i])
                weatherCodesNight.append(dailyDetailedReport.hourly.weathercode[i])
                UVIndexNight.append(dailyDetailedReport.hourly.uvIndex[i])
            }
        }
        
        self._maxTemperatureDay = temperaturesDay.max() ?? 0
        self._maxTemperatureNight = temperaturesNight.max() ?? 0
        
        self._maxApparentTemperatureDay = apparentTemperaturesDay.max() ?? 0
        self._maxApparentTemperatureNight = apparentTemperaturesNight.max() ?? 0
        
        self._maxWindSpeedDay = windSpeedsDay.max() ?? 0
        self._maxWindSpeedNight = windSpeedsNight.max() ?? 0
        
        self.maxPrecipitationProbabilityDay = precipitationPrbabilitiesDay.max() ?? 0
        self.maxPrecipitationProbabilityNight = precipitationPrbabilitiesNight.max() ?? 0
        
        self.windDirectionsDay = windDirectionsDay
        self.windDirectionsNight = windDirectionsNight
        
        self.cloudCoverDay = cloudCoverDay
        self.cloudCoverNight = cloudCoverNight
        
        self.weatherCodesDay = weatherCodesDay
        self.weatherCodesNight = weatherCodesNight
        
        self.maxUVIndexDay = UVIndexDay.max() ?? 0
        self.maxUVIndexNight = UVIndexNight.max() ?? 0
        
        
        if let sunriseString = dailyDetailedReport.daily.sunrise.first {
            _sunrise = Date.from(iso8601String: sunriseString, utcOffsetSeconds: dailyDetailedReport.utcOffsetSeconds)
        } else { _sunrise = nil }
        
        if let sunsetString = dailyDetailedReport.daily.sunset.first {
            _sunset = Date.from(iso8601String: sunsetString, utcOffsetSeconds: dailyDetailedReport.utcOffsetSeconds)
        } else { _sunset = nil }
    }
    
    // MARK: - Private methods
    
    private func averageValue(of intArray: [Int]) -> Int {
        let lenght = intArray.count
        let sum = intArray.reduce(0, +)
        
        return sum / lenght
        
    }
    
    private func mostFrequentElement(of intArray: [Int]) -> Int {
        let counts = intArray.reduce(into: [:]) {
            return $0[$1, default: 0] += 1
        }
        return counts.max(by: { $0.1 < $1.0})?.key ?? 0
    }
    
    private func checkTemperatureUnit(_ initialCelcius: Double) -> Double {
        if UserDefaults.standard.integer(forKey: "temperatureUnit") == 1 {
            return initialCelcius * 9 / 5 + 32
        } else {
            return initialCelcius
        }
    }
    
    private func checkWindSpeedUnit(_ initialKilometersPerHour: Double) -> Double {
        if UserDefaults.standard.integer(forKey: "speedUnit") == 1 {
            return initialKilometersPerHour * 0.5144
        } else {
            return initialKilometersPerHour * 0.278
        }
    }
    
}

// MARK: - DailyDetailedReport
struct DailyDetailedReport: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let hourlyUnits: DailyReportHourlyUnits
    let hourly: DailyReportHourly
    let dailyUnits: DailyReportDailyUnits
    let daily: DailyReportDaily

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
struct DailyReportDaily: Codable {
    let time, sunrise, sunset: [String]
}

// MARK: - DailyUnits
struct DailyReportDailyUnits: Codable {
    let time, sunrise, sunset: String
}

// MARK: - Hourly
struct DailyReportHourly: Codable {
    let time: [String]
    let temperature2M, apparentTemperature: [Double]
    let precipitationProbability, weathercode, cloudcover: [Int]
    let windspeed10M: [Double]
    let winddirection10M: [Int]
    let uvIndex: [Double]
    let isDay: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitationProbability = "precipitation_probability"
        case weathercode, cloudcover
        case windspeed10M = "windspeed_10m"
        case winddirection10M = "winddirection_10m"
        case uvIndex = "uv_index"
        case isDay = "is_day"
    }
}

// MARK: - HourlyUnits
struct DailyReportHourlyUnits: Codable {
    let time, temperature2M, apparentTemperature, precipitationProbability: String
    let weathercode, cloudcover, windspeed10M, winddirection10M: String
    let uvIndex, isDay: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitationProbability = "precipitation_probability"
        case weathercode, cloudcover
        case windspeed10M = "windspeed_10m"
        case winddirection10M = "winddirection_10m"
        case uvIndex = "uv_index"
        case isDay = "is_day"
    }
}
