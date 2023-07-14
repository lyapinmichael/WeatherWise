//
//  MainViewModel.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.07.2023.
//

import Foundation

final class WWMainViewModel {
    
    enum State {
        case initial
        case didUpdateLocation(String)
        case didUpdateWeeklyWeatherForecast(SevenDayWeahterForecast)
        
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
    
    // MARK: - Public methods
    
    // TODO: - Needs optimisation
    func decodeWMOcode(_ code: Int, isDay: Bool) -> String {
        var daytime: String
        
        switch isDay {
        case true:
            daytime = "day"
        case false:
            daytime = "night"
        }
        
        guard let path = Bundle.main.path(forResource: "WMOCodes", ofType: "json") else {
            print("Failed to acces WMO codes data")
            return "" }
        let codeString = String(code)
        
        do {
            let data = try Data(contentsOf: URL(filePath: path))
            let serializedData = try JSONSerialization.jsonObject(with: data)
            
            if let serializedData = serializedData as? [String: Any],
               let codeInfo = serializedData[codeString] as? [String: Any],
               let time = codeInfo[daytime] as? [String: Any],
               let description = time["description"] as? String {
                return description
            }
        } catch {
            preconditionFailure(error.localizedDescription)
        }
        return ""
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
        guard let currentLocationDegrees = (notification.userInfo?["currentLocation"]) as? [Float] else { return }
        state = .didUpdateLocation("\(currentLocationDegrees[0]), \(currentLocationDegrees[1])")
        
        // TODO: - uncomment the following line to decode coordinates into location name
//        self.networkService.decodeLocation(from: currentLocationDegrees)
        
        networkService.getSevenDayWeatherForecast(longitude: currentLocationDegrees[0], latitude: currentLocationDegrees[1])
        
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
    
    
}
