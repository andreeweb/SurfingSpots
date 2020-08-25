//
//  WeatherService.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/22/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

class WeatherService: WeatherServiceProtocol {
    
    // HTTP Service Class for make HTTP requests
    private var httpService: HTTPServiceProtocol
    
    init(httpService: HTTPServiceProtocol) {
        self.httpService = httpService
    }
    
    func getWeatherForCity(city: String) -> AnyPublisher<WeatherData, WeatherServiceError> {
        
        let url = WeatherServiceConfig.weatherEndpoint
        
        return httpService.makeHttpRequest(endpoint: url)
            .mapError { _ in return WeatherServiceError.WeatherNotAvailable }
            .map { httpRespose in return String(decoding: httpRespose.data, as: UTF8.self) }
            .tryMap{ string in return try WeatherData(temperature: self.parseNumber(string)) }
            .mapError { error in return error as! WeatherServiceError }
            .eraseToAnyPublisher()
    }
    
    /// It returns the first number encounter in the string passed
    ///
    /// - Returns: The number extraceted
    private func parseNumber(_ string: String) throws -> Float {
        
        let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        if let number = Float(stringArray[0]) {
            return number
        }else{
            throw WeatherServiceError.ParsingDataError
        }
    }
}
