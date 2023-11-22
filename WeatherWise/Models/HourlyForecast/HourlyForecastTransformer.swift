//
//  HourlyTemperatureTransformer.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 14.09.2023.
//

import Foundation

final class HourlyForecastTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let hourlyForecast = value as? HourlyForecastModel else {
            print("Unable to transform Hourly forecast model to data")
            return nil
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: hourlyForecast, requiringSecureCoding: false)
            return data
        } catch {
            print(error)
            return nil
        }
        
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        
        guard let data = value as? Data else {
            print("Unable to parse data to Hourly forecast model")
            return nil
        }
        
        do {
            let hourlyForecast = try NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [HourlyForecastModel.self,
                            NSArray.self,
                            NSString.self,
                            NSNumber.self,
                            NSDate.self
                           ],
                from: data)
            return hourlyForecast
        } catch {
            print(error)
            return nil
        }
        
    }
    
}
