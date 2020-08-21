//
//  HTTPServiceProtocol.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

protocol HTTPServiceProtocol {
    
    /// This function makes HTTP request to the endpoint passed and returns
    /// results wrapped into HTTPServiceResponse object. If an error occurs
    /// this function returns a HTTPServiceError.
    ///
    /// - Parameter endpoint: request endpoint
    /// - Returns: AnyPublisher<HTTPServiceResponse, HTTPServiceError>
    func makeHttpRequest(endpoint: String) -> AnyPublisher<HTTPServiceResponse, HTTPServiceError>
}
