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
    private var sub: AnyCancellable?
    
    init(httpService: HTTPServiceProtocol) {
        self.httpService = httpService
    }
    
    /*func getCities() -> AnyPublisher<[City], CityServiceError> {
                
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
    }*/
    
    func getCities(completionHandler: @escaping (Result<[City], CityServiceError>)  -> Void ) -> RequestCancelProtocol {
        
        let url = CityServiceConfig.citiesEndpoint
        
        sub = httpService.makeHttpRequest(endpoint: url)
            .map { httpRespose in return httpRespose.data }
            .decode(type: Cities.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                
                /*switch error {
                case is Swift.DecodingError:
                    completionHandler(.failure(CityServiceError.InvalidJsonData))
                default:
                    
                    completionHandler(.failure(CityServiceError.CannotRetrieveCities))
                }*/
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case is Swift.DecodingError:
                        completionHandler(.failure(CityServiceError.InvalidJsonData))
                    default:
                        
                        completionHandler(.failure(CityServiceError.CannotRetrieveCities))
                    }
                }
                
            }, receiveValue: { decodedCities in
                completionHandler(.success(decodedCities.cities))
            })
        
        return sub!
        
            /*.mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    completionHandler(.failure(CityServiceError.InvalidJsonData))
                default:

                    completionHandler(.failure(CityServiceError.CannotRetrieveCities))
                }
            })
            .map{ result in result.cities }
            .sink(receiveValue: { cities in
                completionHandler(.success(cities))
            })*/
    }
}
