//
//  File.swift
//  SurfingSpotsTests
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

enum JSONType {
    case JSONError
    case CitiesJson
    case WeatherResponse
}

class HTTPServiceMock: HTTPServiceProtocol {
    
    /// Used for select the mock json response
    var jsonType: JSONType?
    var validHTTPConnection: Bool = true
    
    func makeHttpRequest(endpoint: String) -> AnyPublisher<HTTPServiceResponse, HTTPServiceError> {
        
        guard URL(string: endpoint) != nil else {
            return Fail(error: HTTPServiceError.HTTPEndpointNotValid).eraseToAnyPublisher()
        }
        
        if !validHTTPConnection {
            return Fail(error: HTTPServiceError.HTTPRequestError(reason: "Mock error")).eraseToAnyPublisher()
        }
        
        var jsonData: Data? = "".data(using: .utf8)
        
        switch jsonType! {
        case .CitiesJson:
            jsonData = """
            {
                "cities": [{
                    "name": "Cuba"
                }, {
                    "name": "Los Angeles"
                }, {
                    "name": "Miami"
                }, {
                    "name": "Porto"
                }, {
                    "name": "Ortona"
                }, {
                    "name": "Riccione"
                }, {
                    "name": "Midgar"
                }]
            }
            """.data(using: .utf8)
        case .JSONError:
            jsonData = "{]".data(using: .utf8)
        case .WeatherResponse:
            jsonData = "6953 is 66 + 999 + 5555 + 333.".data(using: .utf8)
        }
        
        return Just(HTTPServiceResponse(data: jsonData!))
            .setFailureType(to: HTTPServiceError.self)
            .eraseToAnyPublisher()
    }
}
