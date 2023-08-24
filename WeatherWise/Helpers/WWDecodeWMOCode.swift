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
   
    static func decodeWMOcode(_ code: Int, isDay: Bool) -> WMODecoded? {

        let daytime = isDay ? "day" : "night"
        
        guard let path = Bundle.main.path(forResource: "WMOCodes", ofType: "json") else {
            print("Failed to acces WMO codes data")
            return nil }
        
        let codeString = String(code)
        
        do {
            let data = try Data(contentsOf: URL(filePath: path))
            typealias WMOCodeStringArray = [String: WMODecodedIntermediate]
            let jsonDecoder = JSONDecoder()
            let serializedData = try jsonDecoder.decode(WMOCodeStringArray.self, from: data )
            
            let currentCode = serializedData.first(where: { $0.key == codeString})
            
            let description = currentCode?.value.day.description ?? "Failed to decode WMO code description"
            let image = UIImage(named: currentCode?.value.day.image ?? "")
            return WMODecoded(description: description, image: image)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
        
    }
}

struct WMODecoded {
    let description: String
    let image: UIImage?
}

private struct WMODecodedIntermediate: Codable {
    let day: WMODay
}

private struct WMODay: Codable {
    let description, image: String
}

