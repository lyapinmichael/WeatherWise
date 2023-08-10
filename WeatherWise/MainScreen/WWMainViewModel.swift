//
//  MainViewModel.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.07.2023.
//

import Foundation
import CoreLocation

final class WWMainViewModel {
    
    enum State {
        case initial
        case didUpdateLocation(String)
        case didUpdateWeeklyWeatherForecast(SevenDayWeatherForecastModel)
        case didUpdateTodayOverallForecast(DailyOverallForecastModel)
        case didUpdateHourlyTemperature(HourlyTemperatureModel)
        
    }
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    weak var delegate: WWMainViewController?
    
    // MARK: - Service properties
    
    private var networkService = WWNetworkService()
    
    
    // MARK: - Init
    
    init() {
        
        addObservers()
        networkService.delegate = self
        
    }

    // MARK: - Public methods
    
    func updateLocation(with location: CLLocation) {
        let locationDegrees: [Float] = [Float(location.coordinate.longitude), Float(location.coordinate.latitude)]
        
        WWLocationService.shared.reverseGeoDecode(from: location) { [weak self] locality, country, timezone in
            
            guard let localitySafe = locality,
                  let countrySafe = country,
                  let timezoneSafe = timezone else {
                
                self?.state = .didUpdateLocation("\(locationDegrees[1]), \(locationDegrees[0])")
                return
            }

            self?.state = .didUpdateLocation("\(localitySafe), \(countrySafe)")
            self?.getForecasts(longitude: locationDegrees[0], latitude: locationDegrees[1], timezone: timezoneSafe)
        }
    }

    
    // MARK: - Private methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLocation(_:)),
                                               name: WWCLNotifications.locationReceived,
                                               object: nil)
    }
        
    private func getForecasts(longitude: Float, latitude: Float, timezone: String?) {
        
        networkService.getSevenDayWeatherForecast(longitude: longitude, latitude: latitude, timezone: timezone)
        networkService.getTodayWeatherForecast(longitude: longitude, latitude: latitude, timezone: timezone)
        networkService.getHourlyTemperature(longitude: longitude, latitude: latitude, timezone: timezone)
        
    }
    
    // MARK: - ObjC methods
    
    @objc private func updateLocation(_ notification: Notification) {
        guard let currentLocationDegrees = (notification.userInfo?["currentLocationDegrees"]) as? [Float],
              let currentLocation = (notification.userInfo?["currentLocation"]) as? CLLocation,
              let currentTimezone = (notification.userInfo?["currentTimezone"]) as? String else { return }
        
        WWLocationService.shared.reverseGeoDecode(from: currentLocation) { [weak self] locality, country, _ in
            guard let localitySafe = locality,
                  let countrySafe = country else {
                self?.state = .didUpdateLocation("\(currentLocationDegrees[1]), \(currentLocationDegrees[0])")
                return
            }
            self?.state = .didUpdateLocation("\(localitySafe), \(countrySafe)")
        }
        getForecasts(longitude: currentLocationDegrees[0], latitude: currentLocationDegrees[1], timezone: currentTimezone)
    }
    
}

extension WWMainViewModel: WWNetworkServiceDelegate {
    
//    func networkService(didRecieveLocation decodedGeodata: GeocoderResponse) {
//        let locationName = decodedGeodata.response.geoObjectCollection.featureMember[0].geoObject.name
//        state = .didUpdateLocation(locationName)
//    }
    
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast) {
        let sevenDayWeatherForecast = SevenDayWeatherForecastModel(from: decodedSevenDayWeatherForecast)
        state = .didUpdateWeeklyWeatherForecast(sevenDayWeatherForecast)
    }
    
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast) {
        let dailyOverallForecast = DailyOverallForecastModel(from: decodedDailyOverallWeatherForecast)
        state = .didUpdateTodayOverallForecast(dailyOverallForecast)
    }
    
    func networkService(didReceiveHourlyTemperature decodedHourlyTemperature: HourlyTemperature) {
        let hourlyTemperature = HourlyTemperatureModel(from: decodedHourlyTemperature)
        state = .didUpdateHourlyTemperature(hourlyTemperature)
        
    }
    
    
}
