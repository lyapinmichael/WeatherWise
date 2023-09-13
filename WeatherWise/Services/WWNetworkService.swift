//
//  WWNetworkService.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.07.2023.
//

import Foundation
import Alamofire

enum WWNSNotifications {
    static let dailyOverallForecastReceived = Notification.Name("dailyOverallForecastReceived")
    static let hourlyTemperatureReceived = Notification.Name("hourlyTemperatureReceived")
}

protocol WWNetworkServiceDelegate: AnyObject {
    

    
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast)
    
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast)
    
    func networkService(didReceiveHourlyForecast decodedHourlyTemperature: HourlyTemperature)
    
    func networkService(didReceiveDailyDetailedReport decodedDailyDetailedReport: DailyDetailedReport)
    
    func networkService(didReceiveAirQualityIndex decodedAirQualityIndex: AirQualityIndex)
    
    func networkServiceFailedToGetAirQuality()
}

extension WWNetworkServiceDelegate {
    

    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast) {}
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast) {}
    
    func networkService(didReceiveHourlyForecast decodedHourlyTemperature: HourlyTemperature) {}
    
    func networkService(didReceiveDailyDetailedReport decodedDailyDetailedReport: DailyDetailedReport) {}
    
    func networkService(didReceiveAirQualityIndex decodedAirQualityIndex: AirQualityIndex) {}
    
    func networkServiceFailedToGetAirQuality() {}
}

final class WWNetworkService {
    
    weak var delegate: WWNetworkServiceDelegate?
        
    // MARK: - Methods to access Open-Meteo API
    
    func getSevenDayWeatherForecast(longitude: Float, latitude: Float, timezoneIdentifier: String?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = Date().dayAfter,
              let endDate = Date().weekAfter else { return }
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        let timezonePrepared = timezoneIdentifier?.replacingOccurrences(of: "/", with: "%2F") ?? "auto"
        
        let openMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=\(timezonePrepared)&start_date=\(startDateString)&end_date=\(endDateString)"
        
        AF.request(openMeteoURL).responseDecodable(of: SevenDayWeahterForecast.self) { [weak self] response in
            guard let decodedSevenDayWeatherForecast = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n")
                print(response.error)
                return
            }
            
            self?.delegate?.networkService(didReceiveSevenDayWeatherForecast: decodedSevenDayWeatherForecast)
        }
    }
    
    func getTodayWeatherForecast(longitude: Float, latitude: Float, timezoneIdentifier: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = dateFormatter.string(from: Date())
        let timezonePrepared = timezoneIdentifier?.replacingOccurrences(of: "/", with: "%2F") ?? "auto"
        
        let openMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,windspeed_10m,weathercode&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_probability_max,windspeed_10m_max&timezone=\(timezonePrepared)&forecast_days=1"
        
        AF.request(openMeteoURL).responseDecodable(of: DailyOverallForecast.self) { [weak self] response in
            guard let decodedDailyOverallForecast = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n")
                print(response.error)
                return
            }
            
            self?.delegate?.networkService(didReceiveDailyOverallForecast: decodedDailyOverallForecast)
            
        }
    }
    
    func getDailyDetailedReport(longitude: Float, latitude: Float, timezoneIdentifier: String?, date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let timezonePrepared = timezoneIdentifier?.replacingOccurrences(of: "/", with: "%2F") ?? "auto"
        
        let openMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,apparent_temperature,precipitation_probability,weathercode,cloudcover,windspeed_10m,winddirection_10m,uv_index,is_day&daily=sunrise,sunset&timezone=\(timezonePrepared)&start_date=\(dateString)&end_date=\(dateString)"
        
        AF.request(openMeteoURL).responseDecodable(of: DailyDetailedReport.self) { [weak self] response in
            
            guard let decodedDailyDetailedReport = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n")
                print(response.error)
                return
            }
            
            self?.delegate?.networkService(didReceiveDailyDetailedReport: decodedDailyDetailedReport)
            
        }
    }
    
    func getHourlyAirQuailtyIndex(longitude: Float, latitude: Float, timezoneIdentifier: String?, date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let openMeteoURL = "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=\(latitude)&longitude=\(longitude)&hourly=european_aqi&start_date=\(dateString)&end_date=\(dateString)"
        print(openMeteoURL)
        
        AF.request(openMeteoURL).responseDecodable(of: AirQualityIndex.self) { [weak self] response in
            
            guard let decodedAirQualityIndex = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n")
                print(response.error)
                self?.delegate?.networkServiceFailedToGetAirQuality()
                return

            }
            
            self?.delegate?.networkService(didReceiveAirQualityIndex: decodedAirQualityIndex)
            
        }
    }
    
    func getHourlyForecast(longitude: Float, latitude: Float, timezoneIdentifier: String?) {
        
        let timezonePrepared = timezoneIdentifier?.replacingOccurrences(of: "/", with: "%2F") ?? "auto"
        
        let openMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,precipitation_probability,weathercode,cloudcover,windspeed_10m,winddirection_10m&forecast_days=1&timezone=\(timezonePrepared)"
        
        AF.request(openMeteoURL).responseDecodable(of: HourlyTemperature.self) { [weak self] response in
            guard let decodedHourlyTemperature = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n")
                print(response.error)
                return
            }
            
            self?.delegate?.networkService(didReceiveHourlyForecast: decodedHourlyTemperature)
            
        }
    }
}
