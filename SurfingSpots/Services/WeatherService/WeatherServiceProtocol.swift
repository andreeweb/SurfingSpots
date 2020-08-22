//
//  WeatherServiceProtocol.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/22/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    
    /// It returns the weathe for the city name passed
    ///
    /// - Returns: AnyPublisher<[Double], CityServiceError>
    func getWeatherForCity(city: String) -> AnyPublisher<WeatherData, WeatherServiceError>
}
