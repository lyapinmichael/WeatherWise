//
//  DecodedLocation.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.08.2023.
//

import Foundation
import CoreLocation

struct DecodedLocation {
    let longitude, latitude: Double
    let country, locality, timezoneIdentifier: String
    let lastSavedHourlyForecast: HourlyForecastModel?
    let lastSavedSevenDayForecast: SevenDayWeatherForecastModel?
    
    init(from placemark: CLPlacemark) {
        self.longitude = placemark.location?.coordinate.longitude ?? 0.0
        self.latitude = placemark.location?.coordinate.latitude ?? 0.0
        self.country = placemark.country ?? "Unknown country"
        self.locality = placemark.locality ?? "Unknown locality"
        self.timezoneIdentifier = placemark.timeZone?.identifier ?? "GMT"
        lastSavedHourlyForecast = nil
        lastSavedSevenDayForecast = nil
    }
    
    init(from savedLocation: SavedLocation) {
        self.longitude = savedLocation.longitude
        self.latitude = savedLocation.latitude
        self.country = savedLocation.country ?? "Unknown country"
        self.locality = savedLocation.locality ?? "Unknown locality"
        self.timezoneIdentifier = savedLocation.timezoneIdentifier ?? "GMT"
        self.lastSavedHourlyForecast = savedLocation.lastSavedHourlyForecast
        self.lastSavedSevenDayForecast = savedLocation.lastSavedSevenDayForecast
    }

}
