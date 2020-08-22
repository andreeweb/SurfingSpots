//
//  WeatherServiceMock.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/22/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

class WeatherServiceMock: WeatherServiceProtocol {
    
    func getWeatherForCity(city: String) -> AnyPublisher<WeatherData, WeatherServiceError> {
        
        return Just(WeatherData(temperature: Double.random(in: 0..<255)))
            .setFailureType(to: WeatherServiceError.self)
            .eraseToAnyPublisher()
    }
}
