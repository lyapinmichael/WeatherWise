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
    
    init(longitude: Double, latitude: Double, country: String, locality: String, timezoneIdentifier: String) {
        self.longitude = longitude
        self.latitude = latitude
        self.country = country
        self.locality = locality
        self.timezoneIdentifier = timezoneIdentifier
    }
    
    init(from placemark: CLPlacemark) {
        self.longitude = placemark.location?.coordinate.longitude ?? 0.0
        self.latitude = placemark.location?.coordinate.latitude ?? 0.0
        self.country = placemark.country ?? "Unknown country"
        self.locality = placemark.locality ?? "Unknown locality"
        self.timezoneIdentifier = placemark.timeZone?.identifier ?? "GMT"
    }
    
    init(from savedLocation: SavedLocation) {
        self.longitude = savedLocation.longitude
        self.latitude = savedLocation.latitude
        self.country = savedLocation.country ?? "Unknown country"
        self.locality = savedLocation.locality ?? "Unknown locality"
        self.timezoneIdentifier = savedLocation.timezoneIdentifier ?? "GMT"
    }

}
