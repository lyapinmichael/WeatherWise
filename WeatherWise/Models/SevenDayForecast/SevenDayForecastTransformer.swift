//
//  SevenDayForecastTransformer.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 15.09.2023.
//

import Foundation

final class SevenDayForecastTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let sevenDayForecast = value as? SevenDayWeatherForecastModel else {
            print("Unable to transform Seven day forecast model to data")
            return nil
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: sevenDayForecast, requiringSecureCoding: false)
            return data
        } catch {
            print(error)
            return nil
        }
        
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        
        guard let data = value as? Data else {
            print("Unable parse data from Seven day forecast model")
            return nil
        }
        
        do {
            let sevenDayForecast = try NSKeyedUnarchiver.unarchivedObject(
                ofClasses:  [SevenDayWeatherForecastModel.self,
                             NSArray.self,
                             NSNumber.self,
                             NSString.self,
                             NSDate.self],
                from: data)
            return sevenDayForecast
        } catch {
            print(error)
            return nil
        }
    }
}
