//
//  HTTPService.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

class HTTPService: HTTPServiceProtocol {
    
    func makeHttpRequest(endpoint: String) -> AnyPublisher<HTTPServiceResponse, HTTPServiceError> {
        
        guard let url = URL(string: endpoint) else {
            return Fail(error: HTTPServiceError.HTTPEndpointNotValid).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { data, response in
                                                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPServiceError.HTTPResponseError
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw HTTPServiceError.HTTPError(statusCode: httpResponse.statusCode)
                }
                
                let httpResponseResult = HTTPServiceResponse(data: data)
                return httpResponseResult
            }
            .mapError { error in
                
                return HTTPServiceError.HTTPRequestError(reason: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
