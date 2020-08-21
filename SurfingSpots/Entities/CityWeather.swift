//
//  CityWeather.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import UIKit

struct CityWeather: Identifiable {
    
    var id = UUID()
    let name: String
    let image: UIImage
    var temperature: Float
    let weather: WeatherCondition
}
