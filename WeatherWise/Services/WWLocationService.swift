//
//  WWCoreLocationService.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 06.07.2023.
//

import Foundation
import CoreLocation

enum WWCLNotifications {
    static let authorizationChanged = Notification.Name("permissionChanged")
    static let locationReceived = Notification.Name("locationReceived")
}

final class WWLocationService: NSObject {
    
    // MARK: - Singleton instance
    
    static var shared = WWLocationService()
    
    // MARK: - Public propertis
    
    var authorizationStatus: CLAuthorizationStatus?
    
//    var currentLocation: CLLocation?
    
    // MARK: - Private propertis
    
    private var coreLocationManager = CLLocationManager()
    
    // MARK: - Init
    
    override init() {
        super.init()
        coreLocationManager.delegate = self
        authorizationStatus = coreLocationManager.authorizationStatus
        
    }
    
    // MARK: - Public functions
    
    func getPermission() {
        self.coreLocationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        self.coreLocationManager.requestLocation()
    }
    
    func reverseGeoDecode(from location: CLLocation, completion: @escaping (String?, String?, String?) -> Void) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { locationName, error  in
            guard let location = locationName?.last else {
                print(error ?? "Something went wrong while performing reverse geocoding")
                return
            }
            
            completion(location.locality, location.country, location.timeZone?.identifier)
        }
    }
    
    func geocode(from addressString: String, completion: @escaping (DecodedLocation) -> Void) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(addressString) { placemarks, error in
            if let error {
                print(error)
            }
            
            guard let placemark = placemarks?[0] else {
                print (error ?? "Something went wrong while performing reverse geocoding")
                return
            }
            
            let decodedLocation = DecodedLocation(from: placemark)
            
            completion(decodedLocation)
            
        }
    }
}

extension WWLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        print("locationMangerDidChangeAuthorization, \(authorizationStatus?.rawValue)")
        
        if case .authorizedWhenInUse = authorizationStatus {
            let userInfo = ["authStatus": true]
            NotificationCenter.default.post(name: WWCLNotifications.authorizationChanged,
                                            object: nil,
                                            userInfo: userInfo)
        }
        

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = coreLocationManager.location else { return }
        
//        self.currentLocation = currentLocation
        
        var currentLocationDegrees: [Float] = []
        currentLocationDegrees.append(Float(currentLocation.coordinate.longitude))
        currentLocationDegrees.append(Float(currentLocation.coordinate.latitude))
        
        let currentTimezone = TimeZone.current.identifier
        
        NotificationCenter.default.post(Notification(name: WWCLNotifications.locationReceived, userInfo: ["currentLocationDegrees": currentLocationDegrees, "currentLocation": currentLocation, "currentTimezone": currentTimezone]))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
