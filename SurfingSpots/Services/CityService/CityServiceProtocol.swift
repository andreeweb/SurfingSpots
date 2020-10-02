//
//  CityServiceProtocol.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

protocol CityServiceProtocol {
    
    /// It returns an array of cities.
    ///
    /// - Returns: AnyPublisher<[City], CityServiceError>
    // func getCities() -> AnyPublisher<[City], CityServiceError>
    
    func getCities(completionHandler: @escaping (Result<[City], CityServiceError>)  -> Void )
}
