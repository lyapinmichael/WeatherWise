//
//  WWDecodeWeatherCode.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 18.07.2023.
//

import Foundation

// TODO: - Needs optimisation
func decodeWMOcode(_ code: Int, isDay: Bool) -> [String] {
    var daytime: String
    
    switch isDay {
    case true:
        daytime = "day"
    case false:
        daytime = "night"
    }
    
    guard let path = Bundle.main.path(forResource: "WMOCodes", ofType: "json") else {
        print("Failed to acces WMO codes data")
        return [""] }
    let codeString = String(code)
    
    do {
        let data = try Data(contentsOf: URL(filePath: path))
        let serializedData = try JSONSerialization.jsonObject(with: data)
        
        if let serializedData = serializedData as? [String: Any],
           let codeInfo = serializedData[codeString] as? [String: Any],
           let time = codeInfo[daytime] as? [String: Any],
           let description = time["description"] as? String,
           let image = time["image"] as? String
        {
            return [description, image]
        }
    } catch {
        preconditionFailure(error.localizedDescription)
    }
    return [""]
}
