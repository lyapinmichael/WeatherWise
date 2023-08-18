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
    
//    func networkService(didRecieveLocation decodedGeodata: GeocoderResponse)
    
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast)
    
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast)
    
    func networkService(didReceiveHourlyTemperature decodedHourlyTemperature: HourlyTemperature)
}

extension WWNetworkServiceDelegate {
    
//    func networkService(didRecieveLocation decodedGeodata: GeocoderResponse) {}
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast) {}
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast) {}
    
    func networkService(didReceiveHourlyTemperature decodedHourlyTemperature: HourlyTemperature) {}
    
}

final class WWNetworkService {
    
    weak var delegate: WWNetworkServiceDelegate?
        
    // MARK: - Methods to access Open-Meteo API
    
    // TODO: Add option to choose between Celsius and Fahrenheit
    func getSevenDayWeatherForecast(longitude: Float, latitude: Float, timezoneIdentifier: String?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDateString = dateFormatter.string(from: Date().dayAfter)
        let endDateString = dateFormatter.string(from: Date().dayAfter.weekAfter)
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
    
    func getHourlyTemperature(longitude: Float, latitude: Float, timezoneIdentifier: String?) {
        
        let timezonePrepared = timezoneIdentifier?.replacingOccurrences(of: "/", with: "%2F") ?? "auto"
        
        let openMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weathercode&forecast_days=1&timezone=\(timezonePrepared)"
        
        AF.request(openMeteoURL).responseDecodable(of: HourlyTemperature.self) { [weak self] response in
            guard let decodedHourlyTemperature = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n")
                print(response.error)
                return
            }
            
            self?.delegate?.networkService(didReceiveHourlyTemperature: decodedHourlyTemperature)
            
        }
    }
}
