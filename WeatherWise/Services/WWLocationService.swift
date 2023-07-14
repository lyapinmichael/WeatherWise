//
//  WWCoreLocationService.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 06.07.2023.
//

import Foundation
import CoreLocation

enum WWCLNotifications {
    static let permissionGranted = Notification.Name("permissionGranted")
    static let locationReceived = Notification.Name("locationReceived")
}

final class WWLocationService: NSObject {
    
    var authorizationStatus: CLAuthorizationStatus?
    
    static var currentLocation: CLLocation?
    
    private var coreLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        coreLocationManager.delegate = self
        authorizationStatus = coreLocationManager.authorizationStatus
        
    }
    
    func getPermission() {
        self.coreLocationManager.requestWhenInUseAuthorization()
    }
}

extension WWLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        let userInfo: [String: CLAuthorizationStatus] = ["authStatus": manager.authorizationStatus]
        NotificationCenter.default.post(name: WWCLNotifications.permissionGranted,
                                        object: nil,
                                        userInfo: userInfo)
        
        if case .authorizedWhenInUse = authorizationStatus {
            coreLocationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = coreLocationManager.location else { return }
        
        Self.currentLocation = currentLocation
        
        var currentLocationDegrees: [Float] = []
        currentLocationDegrees.append(Float(currentLocation.coordinate.longitude))
        currentLocationDegrees.append(Float(currentLocation.coordinate.latitude))
        
        NotificationCenter.default.post(Notification(name: WWCLNotifications.locationReceived, userInfo: ["currentLocation": currentLocationDegrees]))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
