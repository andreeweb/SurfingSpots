//
//  File.swift
//  SurfingSpotsTests
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine
import UIKit

enum ResultType {
    case JSONError
    case CitiesJson
    case WeatherResponse
    case ImageData
}

class HTTPServiceMock: HTTPServiceProtocol {
    
    /// Used for select the mock json response
    var jsonType: ResultType?
    var validHTTPConnection: Bool = true
    
    func makeHttpRequest(endpoint: String) -> AnyPublisher<HTTPServiceResponse, HTTPServiceError> {
        
        guard URL(string: endpoint) != nil else {
            return Fail(error: HTTPServiceError.HTTPEndpointNotValid).eraseToAnyPublisher()
        }
        
        if !validHTTPConnection {
            return Fail(error: HTTPServiceError.HTTPRequestError(reason: "Mock error")).eraseToAnyPublisher()
        }
        
        var resultData: Data? = "".data(using: .utf8)
        
        switch jsonType! {
        case .CitiesJson:
            resultData = """
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
            resultData = "{]".data(using: .utf8)
        case .WeatherResponse:
            resultData = "6953 is 66 + 999 + 5555 + 333.".data(using: .utf8)
        case .ImageData:
            resultData = UIImage(imageLiteralResourceName: "city-placeholder").pngData()
        }
        
        return Just(HTTPServiceResponse(data: resultData!))
            .setFailureType(to: HTTPServiceError.self)
            .eraseToAnyPublisher()
    }
}
