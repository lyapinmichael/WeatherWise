//
//  WWDecodeWeatherCode.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 18.07.2023.
//

import Foundation
import UIKit.UIImage
// TODO: - Needs optimisation
struct WMODecoder {
    
    struct WMODecoded {
        var description: String
        var image: UIImage?
    }
    
    static func decodeWMOcode(_ code: Int, isDay: Bool) -> WMODecoded? {

        let daytime = isDay ? "day" : "night"
        
        guard let path = Bundle.main.path(forResource: "WMOCodes", ofType: "json") else {
            print("Failed to acces WMO codes data")
            return nil }
        let codeString = String(code)
        
        do {
            let data = try Data(contentsOf: URL(filePath: path))
            let serializedData = try JSONSerialization.jsonObject(with: data)
            
            if let serializedData = serializedData as? [String: Any],
               let codeInfo = serializedData[codeString] as? [String: Any],
               let time = codeInfo[daytime] as? [String: Any],
               let description = time["description"] as? String,
               let imageString = time["image"] as? String
            {
            
                return WMODecoded(description: description, image: UIImage(named: imageString))
            }
        } catch {
            preconditionFailure(error.localizedDescription)
        }
        return nil
    }
}
