//
//  WeatherCondition.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation

enum WeatherCondition: String {
    case Sunny
    case Cloudy
    case NotAvailable
    
    var localizedDescription: String {
        get {
            switch self {
            case .Sunny:
                return NSLocalizedString("sunny_weather", comment: "")
            case .Cloudy:
                return NSLocalizedString("cloudy_weather", comment: "")
            case .NotAvailable:
                return NSLocalizedString("weather_not_available", comment: "")
            }
        }
    }
}
