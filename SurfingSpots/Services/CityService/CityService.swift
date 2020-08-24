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
            .map { httpRespose in return httpRespose.data }
            .decode(type: Cities.self, decoder: JSONDecoder())
            .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    return CityServiceError.InvalidJsonData
                default:
                    return CityServiceError.CannotRetrieveCities
                }
            })
            .map{ result in result.cities }
            .eraseToAnyPublisher()
    }
}
