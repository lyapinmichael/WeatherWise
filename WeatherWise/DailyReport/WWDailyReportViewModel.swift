//
//  WWDailyReportViewModel.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 11.09.2023.
//

import Foundation

final class WWDailyReportViewModel {
    
    weak var delegate: WWDailyReportViewController?
    
    // MARK: - State
    
    enum State {
        case inital
        case didReceiveDailyDetailedReport(DailyDetailedReportModel)
        case didReceiveAirQualityIndex(AirQualityIndexModel)
        case failedToGetAirQuality
    }
    
    private(set) var state: State = .inital {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: - ViewInput
    
    enum ViewInput {
        case requestDailyReport(DecodedLocation, Date)
        case updateReport(Date)
    }
    
    func updateState(with input: ViewInput) {
        switch input {
        case .requestDailyReport(let coordinates, let date):
            self.currentLocation = coordinates
            
            networkService.getDailyDetailedReport(
                longitude: Float(coordinates.longitude),
                latitude: Float(coordinates.latitude),
                timezoneIdentifier: coordinates.timezoneIdentifier,
                date: date)
            networkService.getHourlyAirQuailtyIndex(
                longitude: Float(coordinates.longitude),
                latitude: Float(coordinates.latitude),
                timezoneIdentifier: coordinates.timezoneIdentifier,
                date: date)
            
        case .updateReport(let date):
            guard let currentLocation = self.currentLocation else { return }
            
            networkService.getDailyDetailedReport(
                longitude: Float(currentLocation.longitude),
                latitude: Float(currentLocation.latitude),
                timezoneIdentifier: currentLocation.timezoneIdentifier,
                date: date)
            networkService.getHourlyAirQuailtyIndex(
                longitude: Float(currentLocation.longitude),
                latitude: Float(currentLocation.latitude),
                timezoneIdentifier: currentLocation.timezoneIdentifier,
                date: date)
        
        }
    }
    
    // MARK: - Private properties
    
    private var networkService = WWNetworkService()
    
    private var currentLocation: DecodedLocation?
    
    // MARK: - Init
    
    init() {
        networkService.delegate = self
    }
}

extension WWDailyReportViewModel: WWNetworkServiceDelegate {
    
    func networkService(didReceiveDailyDetailedReport decodedDailyDetailedReport: DailyDetailedReport) {
        
        let dailyDetailedReport = DailyDetailedReportModel(from: decodedDailyDetailedReport)
        state = .didReceiveDailyDetailedReport(dailyDetailedReport)
    }
    
    func networkService(didReceiveAirQualityIndex decodedAirQualityIndex: AirQualityIndex) {
        
        let airQualityIndex = AirQualityIndexModel(from: decodedAirQualityIndex)
        state = .didReceiveAirQualityIndex(airQualityIndex)
    }
    
    func networkServiceFailedToGetAirQuality() {
        
        state = .failedToGetAirQuality
    }
    
}
