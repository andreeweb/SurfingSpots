//
//  CityService.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

class CityService: CityServiceProtocol {
    
    // HTTP Service Class for make HTTP requests
    private var httpService: HTTPServiceProtocol
    
    init(httpService: HTTPServiceProtocol) {
        self.httpService = httpService
    }
    
    func getCities() -> AnyPublisher<[City], CityServiceError> {
                
        let url = CityServiceConfig.citiesEndpoint
        
        return httpService.makeHttpRequest(endpoint: url)
            //.mapError { _ in return CityServiceError.CannotRetrieveCities } // TODO
            .map { httpRespose in return httpRespose.data }
            .decode(type: Cities.self, decoder: JSONDecoder())
            .map{ cities in return cities.cities }
            .mapError { error in return CityServiceError.InvalidJsonData }
            .eraseToAnyPublisher()
    }
}
