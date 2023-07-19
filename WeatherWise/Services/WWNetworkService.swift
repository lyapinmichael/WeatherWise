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
}

protocol WWNetworkServiceDelegate: AnyObject {
    
    func networkService(didRecieveLocation decodedGeodata: GeocoderResponse)
    
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast)
    
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast)
}

extension WWNetworkServiceDelegate {
    
    func networkService(didRecieveLocation decodedGeodata: GeocoderResponse) {}
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast) {}
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast) {}
    
}

final class WWNetworkService {
    
    weak var delegate: WWNetworkServiceDelegate?
    
    private let yandexGeocoderAPISecureKey: [UInt8] = [48, 101, 97, 99, 49, 98, 49, 102, 45, 102, 97, 55, 52, 45, 52, 53, 51, 102, 45, 97, 49, 52, 53, 45, 52, 51, 56, 97, 55, 53, 49, 97, 50, 52, 100, 102]
    private var yandexGeocoderAPIKey: String? {
        return String(data: Data(yandexGeocoderAPISecureKey), encoding: .utf8)
        
    }
    
//    private let openWeatherAPISecureKey: [UInt8] = [101, 55, 48, 50, 52, 54, 52, 54, 48, 53, 97, 48, 48, 51, 54, 52, 53, 101, 50, 102, 99, 49, 48, 55, 55, 53, 50, 97, 49, 102, 99, 54]
//    private var openWeatherAPIKey: String? {
//        return String(data: Data(openWeatherAPISecureKey), encoding: .utf8)
//    }
 
    
    // MARK: - Methods to access Yandex.Geocoder API
    
    /// Function takes array of floating point numbers, which are meant to be decoded from Longitude and Latitude of CLLocation.
    /// 0 index is for Longitude
    /// 1 index is for Latitude
    /// Abovementioned positioning of Longitude and Latitude conforms to standard positions of coordinate degrees in standard request to Yandex.Geocoder API.
    func decodeLocation(from degrees: [Float]) {
        guard degrees.count == 2 else { return }
        guard let key = yandexGeocoderAPIKey else { return }
        
        let longitude = degrees[0]
        let latitude = degrees[1]
        
        let yandexGeocoderURL = "https://geocode-maps.yandex.ru/1.x/?apikey=\(key)&geocode=\(longitude),\(latitude)&kind=locality&format=json"
        
        AF.request(yandexGeocoderURL).responseDecodable(of: GeocoderResponse.self) { [weak self] response in
            guard let decodedGeodata = response.value else {
                print(response.error?.localizedDescription ?? "Something went wrong. Failed go collect error info.")
                return
            }
            
            self?.delegate?.networkService(didRecieveLocation: decodedGeodata)
        }
    }
    
    // MARK: - Methods to access Open-Meteo API
    
    // TODO: Add option to choose between Celsius and Fahrenheit
    func getSevenDayWeatherForecast(longitude: Float, latitude: Float) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDateString = dateFormatter.string(from: Date().dayAfter)
        let endDateString = dateFormatter.string(from: Date().dayAfter.weekAfter)
        
        let openMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=Europe%2FMoscow&start_date=\(startDateString)&end_date=\(endDateString)"
        
        AF.request(openMeteoURL).responseDecodable(of: SevenDayWeahterForecast.self) { [weak self] response in
            guard let decodedSevenDayWeatherForecast = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n")
                print(response.error)
                return
            }
            
            self?.delegate?.networkService(didReceiveSevenDayWeatherForecast: decodedSevenDayWeatherForecast)
        }
    }
    
    func getTodayWeatherForecast(longitude: Float, latitude: Float) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = dateFormatter.string(from: Date())
        
        let openMeteoURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,windspeed_10m,weathercode&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_probability_max,windspeed_10m_max&timezone=Europe%2FMoscow&forecast_days=1"
        
        AF.request(openMeteoURL).responseDecodable(of: DailyOverallForecast.self) { [weak self] response in
            guard let decodedDailyOverallForecast = response.value else {
                print("Error occured while decoding weahter forecast from OpenMeteo API:\n\n" + (response.error?.localizedDescription ?? "Something went wrong"))
                return
            }
            
            self?.delegate?.networkService(didReceiveDailyOverallForecast: decodedDailyOverallForecast)
        }
        
    }
}
