//
//  WWWindDirectionAngleDecoder.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 11.09.2023.
//

import Foundation

struct WWWindDirectionAngleDecoder {
    
    static func decode(angle: Int) -> String {
        
        switch angle {
        case 0 ..< 22:
            return "С"
        case 22 ..< 45:
            return "СCВ"
        case 45 ..< 67:
            return "СВ"
        case 67 ..< 90:
            return "BCB"
        case 90 ..< 112:
            return "B"
        case 112 ..< 135:
            return "ВЮВ"
        case 135 ..< 157:
            return "ЮВ"
        case 157 ..< 180:
            return "ЮЮВ"
        case 180 ..< 202:
            return "Ю"
        case 202 ..< 225:
            return "ЮЮЗ"
        case 225 ..< 247:
            return "ЮЗ"
        case 247 ..< 270:
            return "ЮЗ"
        case 270 ..< 292:
            return "З"
        case 292 ..< 315:
            return "ЗСЗ"
        case 315 ..< 337:
            return "СЗ"
        case 337 ... 360:
            return "ССЗ"
        default:
            return ""
        }
        
    }
    
}
