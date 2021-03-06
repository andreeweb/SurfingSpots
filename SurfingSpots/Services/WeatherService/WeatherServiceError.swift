//
//  WeatherServiceError.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/22/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation

enum WeatherServiceError: Error {
    case ParsingDataError
    case WeatherNotAvailable
}
