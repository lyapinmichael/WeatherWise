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
    
    lazy var persistentContainer: NSPersistentContainer = {
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
    
    private func localityAlreadySaved(_ locality: String) -> Bool {
        let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "locality == %@", locality)
        return ((try? persistentContainer.viewContext.count(for: fetchRequest)) ?? 0) > 0
       }
    
}
