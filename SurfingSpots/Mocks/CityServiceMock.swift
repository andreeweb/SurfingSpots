//
//  CityServiceMock.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

class CityServiceMock: CityServiceProtocol {
    
    func getCities() -> AnyPublisher<[City], CityServiceError> {
        
        let city1 = City(name: "mock-city-1")
        let city2 = City(name: "mock-city-2")
        let city3 = City(name: "mock-city-3")
        
        let cityArray = [city1, city2, city3]
        
        let cities = Cities(cities: cityArray)
        
        return Just(cities.cities)
            .setFailureType(to: CityServiceError.self)
            .eraseToAnyPublisher()
    }
}
