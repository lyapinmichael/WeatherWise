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
        case didUpdateWeeklyWeatherForecast(SevenDayWeahterForecast)
        case didUpdateHourlyTemperature(HourlyTemperature)
        
    }
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    weak var delegate: WWMainViewController?
    
    // MARK: - Service properties
    
    private var locationService = WWLocationService()
    private var networkService = WWNetworkService()

    
    // MARK: - Init
    
    init() {
        
        addObservers()
        networkService.delegate = self
        
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLocation(_:)),
                                               name: WWCLNotifications.locationReceived,
                                               object: nil)
    }
    
    
    
    // MARK: - ObjC methods
    
    @objc private func updateLocation(_ notification: Notification) {
        guard let currentLocationDegrees = (notification.userInfo?["currentLocationDegrees"]) as? [Float],
              let currentLocation = (notification.userInfo?["currentLocation"]) as? CLLocation,
              let currentTimezone = (notification.userInfo?["currentTimezone"]) as? String else { return }
        
        self.locationService.reverseGeoDecode(from: currentLocation) { [weak self] locality, country in
            guard let localitySafe = locality,
                  let countrySafe = country else {
                self?.state = .didUpdateLocation("\(currentLocationDegrees[1]), \(currentLocationDegrees[0])")
                return
            }
            self?.state = .didUpdateLocation("\(localitySafe), \(countrySafe)")
        }
        
        
        networkService.getSevenDayWeatherForecast(longitude: currentLocationDegrees[0], latitude: currentLocationDegrees[1], timezone: currentTimezone)
        networkService.getTodayWeatherForecast(longitude: currentLocationDegrees[0], latitude: currentLocationDegrees[1], timezone: currentTimezone)
        networkService.getHourlyTemperature(longitude: currentLocationDegrees[0], latitude: currentLocationDegrees[1], timezone: currentTimezone)
        
    }
    
}

extension WWMainViewModel: WWNetworkServiceDelegate {
    
    func networkService(didRecieveLocation decodedGeodata: GeocoderResponse) {
        let locationName = decodedGeodata.response.geoObjectCollection.featureMember[0].geoObject.name
        state = .didUpdateLocation(locationName)
    }
    
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast) {
        state = .didUpdateWeeklyWeatherForecast(decodedSevenDayWeatherForecast)
    }
    
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast) {
        let notification = Notification(name: WWNSNotifications.dailyOverallForecastReceived, userInfo: ["dailyOverallForecast": decodedDailyOverallWeatherForecast])
        NotificationCenter.default.post(notification)
    }
    
    func networkService(didReceiveHourlyTemperature decodedHourlyTemperature: HourlyTemperature) {
        state = .didUpdateHourlyTemperature(decodedHourlyTemperature)
    }
    
    
}
