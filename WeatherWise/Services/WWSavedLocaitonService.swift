//
//  WWCoreDataService.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.08.2023.
//

import Foundation
import CoreData

final class WWSavedLocaitonService {
    
    enum SavedLocationError: Error {
        case locationAlreadySaved
    }
    
    static let shared = WWSavedLocaitonService()
    
    private lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "WWSavedLocation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error as NSError? {
                print("CoreData error: " + error.localizedDescription)
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var savedLocations: [SavedLocation] = []
    
    private init() {
        ValueTransformer.setValueTransformer(HourlyForecastTransformer(), forName: NSValueTransformerName("HourlyForecastTransformer"))
        
        ValueTransformer.setValueTransformer(SevenDayForecastTransformer(), forName: NSValueTransformerName("SevenDayForecastTransformer"))
    }
    
    func fetchSavedLocations() -> [SavedLocation]? {
        let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
        let savedLocations = try? persistentContainer.viewContext.fetch(fetchRequest)
        return savedLocations
    }
    
    func save(location: DecodedLocation) throws {
        
        guard !localityAlreadySaved(location.locality) else { throw SavedLocationError.locationAlreadySaved }
        
        self.persistentContainer.performBackgroundTask({ backgroundContext in
            let savedLocation = SavedLocation.init(context: backgroundContext)
            
            savedLocation.latitude = location.latitude
            savedLocation.longitude = location.longitude
            savedLocation.country = location.country
            savedLocation.locality = location.locality
            savedLocation.timezoneIdentifier = location.timezoneIdentifier
            
            do {
                try backgroundContext.save()
            } catch {
                print(error)
            }
        })
    }
    
    func update(lastReceivedSevenDayForecast forecast: SevenDayWeatherForecastModel, for location: DecodedLocation) {
        
        self.persistentContainer.performBackgroundTask({ backgoundContext in
            
            let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "locality == %@", location.locality)
            fetchRequest.fetchLimit = 1
            
            guard let savedLocation = try? backgoundContext.fetch(fetchRequest) else {
                print("Location \(location.locality) not found in CoreData.")
                return
            }
            
            savedLocation.first?.lastSavedSevenDayForecast = forecast
            
            do {
                try backgoundContext.save()
                print("New seven daty forecast successfully saved")
            } catch {
                print(error)
            }
            
        })
    }
    
    func update(lastReceivedHourlyForecast forecast: HourlyForecastModel, for location: DecodedLocation) {
        
        self.persistentContainer.performBackgroundTask({backgroundContext in
            
            let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "locality == %@", location.locality)
            fetchRequest.fetchLimit = 1
            
            guard let savedLocation = try? backgroundContext.fetch(fetchRequest) else {
                print("Location \(location.locality) not found in CoreData.")
                return
            }
            
            savedLocation.first?.lastSavedHourlyForecast = forecast
            
            do {
                try backgroundContext.save()
                print("New hourly forecast successfully saved")
            } catch {
                print(error)
            }
        
                    
     
        })
        
    }
    
    
    private func localityAlreadySaved(_ locality: String) -> Bool {
        let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "locality == %@", locality)
        return ((try? persistentContainer.viewContext.count(for: fetchRequest)) ?? 0) > 0
       }
    
}
