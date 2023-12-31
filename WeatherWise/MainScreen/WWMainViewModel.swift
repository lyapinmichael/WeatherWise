//
//  MainViewModel.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.07.2023.
//

import Foundation
import CoreLocation

final class WWMainViewModel {
    
    // MARK: - State
    
    enum State {
        case initial
        case willUseGeolocation
        case didUpdateLocation(String)
        case didUpdateWeeklyWeatherForecast(SevenDayWeatherForecastModel)
        case didUpdateTodayOverallForecast(DailyOverallForecastModel)
        case didUpdateHourlyTemperature(HourlyForecastModel)
        case reload
        case didGetPermission
    }
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: - Delegate
    
    weak var delegate: WWMainViewController?
    
    // MARK: - Embedded current location
    
    struct CurrentLocation {
        let longitude: Float
        let latitude: Float
        let timezoneIdentifier: String
    }
    
    var currentLocation: DecodedLocation?
    
    // MARK: - Service properties
    
    private var networkService = WWNetworkService()
    
    
    // MARK: - Init
    
    init() {
        networkService.delegate = self
    }
    
    convenience init(_ type: WWPageFactory.PageType) {
        
        self.init()
        
        if case .mainPageWithLocationDetected = type {
            addLocationObservers()
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
        let timezoneIdentifier = location.timezoneIdentifier
        
        currentLocation = location
        
        state = .didUpdateLocation("\(location.locality), \(location.country)")
        
        if let lastSavedHourlyForecast = location.lastSavedHourlyForecast {
            state = .didUpdateHourlyTemperature(lastSavedHourlyForecast)
        }
        
        if let lastSavedSevenDayForecast = location.lastSavedSevenDayForecast {
            state = .didUpdateWeeklyWeatherForecast(lastSavedSevenDayForecast)
        }
        
        getForecasts(longitude: longitude, latitude: latitude, timezoneIdentifier: timezoneIdentifier)
    }

    
    // MARK: - Private methods
    
    private func addLocationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocation(_:)),
            name: WWCLNotifications.locationReceived,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocationPinButton),
            name: WWCLNotifications.authorizationChanged,
            object: nil
        )
    }
        
    private func getForecasts(longitude: Float, latitude: Float, timezoneIdentifier: String?) {
        
        networkService.getSevenDayWeatherForecast(longitude: longitude, latitude: latitude, timezoneIdentifier: timezoneIdentifier)
        networkService.getTodayWeatherForecast(longitude: longitude, latitude: latitude, timezoneIdentifier: timezoneIdentifier)
        networkService.getHourlyForecast(longitude: longitude, latitude: latitude, timezoneIdentifier: timezoneIdentifier)
        
    }
    
    // MARK: - ObjC methods
    
    @objc private func updateLocation(_ notification: Notification) {
        guard let currentLocationDegrees = (notification.userInfo?["currentLocationDegrees"]) as? CLLocationCoordinate2D,
              let currentLocation = (notification.userInfo?["currentLocation"]) as? CLLocation,
              let currentTimezone = (notification.userInfo?["currentTimezone"]) as? String else { return }
        
        WWLocationService.shared.reverseGeoDecode(from: currentLocation) { [weak self] placemark, locality, country, _ in
            guard let localitySafe = locality,
                  let countrySafe = country,
                  let placemarkSafe = placemark else {
                self?.state = .didUpdateLocation("Unknown location")
                return
            }
            self?.currentLocation = DecodedLocation(from: placemarkSafe)
            self?.state = .didUpdateLocation("\(localitySafe), \(countrySafe)")
        }
        
        getForecasts(longitude: Float(currentLocationDegrees.longitude), latitude: Float(currentLocationDegrees.latitude), timezoneIdentifier: currentTimezone)
    }
    
    @objc private func updateUnits() {
        state = .reload
    }
    
    @objc private func updateLocationPinButton() {
        state = .didGetPermission
    }
}

extension WWMainViewModel: WWNetworkServiceDelegate {
    
    func networkService(didReceiveSevenDayWeatherForecast decodedSevenDayWeatherForecast: SevenDayWeahterForecast) {
        let sevenDayWeatherForecast = SevenDayWeatherForecastModel(from: decodedSevenDayWeatherForecast)
        state = .didUpdateWeeklyWeatherForecast(sevenDayWeatherForecast)
        
        if let currentLocation = self.currentLocation {
            WWSavedLocaitonService.shared.update(lastReceivedSevenDayForecast: sevenDayWeatherForecast, for: currentLocation)
        }
    }
    
    func networkService(didReceiveDailyOverallForecast decodedDailyOverallWeatherForecast: DailyOverallForecast) {
        let dailyOverallForecast = DailyOverallForecastModel(from: decodedDailyOverallWeatherForecast)
        state = .didUpdateTodayOverallForecast(dailyOverallForecast)
    }
    
    func networkService(didReceiveHourlyForecast decodedHourlyTemperature: HourlyTemperature) {
        let hourlyTemperature = HourlyForecastModel(from: decodedHourlyTemperature)
        state = .didUpdateHourlyTemperature(hourlyTemperature)
        
        if let currentLocation = self.currentLocation {
            WWSavedLocaitonService.shared.update(lastReceivedHourlyForecast: hourlyTemperature, for: currentLocation)
        }
        
    }
    
}
