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
        case willUseGeolocation
        case didUpdateLocation(String)
        case didUpdateWeeklyWeatherForecast(SevenDayWeatherForecastModel)
        case didUpdateTodayOverallForecast(DailyOverallForecastModel)
        case didUpdateHourlyTemperature(HourlyTemperatureModel)
        case reload
        
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
        networkService.delegate = self
    }
    
    convenience init(_ type: WWPageFactory.PageType) {
        
        self.init()
        
        if case .mainPageWithLocationDetected = type {
            addLocationChangeObservers()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUnits),
                                               name: WWSettingsNotification.unitsUpdated, object: nil)
    }
    
    // MARK: - Public methods
    
    func willUseGeolocation() {
        state = .willUseGeolocation
    }
    
    func updateLocation(with location: DecodedLocation) {
        let longitude = Float(location.longitude)
        let latitude = Float(location.latitude)
        
        state = .didUpdateLocation("\(location.locality), \(location.country)")
        getForecasts(longitude: longitude, latitude: latitude, timezoneIdentifier: location.timezoneIdentifier)
    }

    
    // MARK: - Private methods
    
    private func addLocationChangeObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLocation(_:)),
                                               name: WWCLNotifications.locationReceived,
                                               object: nil)
        
    }
        
    private func getForecasts(longitude: Float, latitude: Float, timezoneIdentifier: String?) {
        
        networkService.getSevenDayWeatherForecast(longitude: longitude, latitude: latitude, timezoneIdentifier: timezoneIdentifier)
        networkService.getTodayWeatherForecast(longitude: longitude, latitude: latitude, timezoneIdentifier: timezoneIdentifier)
        networkService.getHourlyTemperature(longitude: longitude, latitude: latitude, timezoneIdentifier: timezoneIdentifier)
        
    }
    
    // MARK: - ObjC methods
    
    @objc private func updateLocation(_ notification: Notification) {
        guard let currentLocationDegrees = (notification.userInfo?["currentLocationDegrees"]) as? CLLocationCoordinate2D,
              let currentLocation = (notification.userInfo?["currentLocation"]) as? CLLocation,
              let currentTimezone = (notification.userInfo?["currentTimezone"]) as? String else { return }
        
        WWLocationService.shared.reverseGeoDecode(from: currentLocation) { [weak self] locality, country, _ in
            guard let localitySafe = locality,
                  let countrySafe = country else {
                self?.state = .didUpdateLocation("Unknown location")
                return
            }
            self?.state = .didUpdateLocation("\(localitySafe), \(countrySafe)")
        }
        
        getForecasts(longitude: Float(currentLocationDegrees.longitude), latitude: Float(currentLocationDegrees.latitude), timezoneIdentifier: currentTimezone)
    }
    
    @objc private func updateUnits() {
        state = .reload
    }
    
}

extension WWMainViewModel: WWNetworkServiceDelegate {
    
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
