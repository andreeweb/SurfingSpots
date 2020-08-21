//
//  File.swift
//  SurfingSpotsTests
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

class HTTPServiceMock: HTTPServiceProtocol {
    
    func makeHttpRequest(endpoint: String) -> AnyPublisher<HTTPServiceResponse, HTTPServiceError> {
        
        guard URL(string: endpoint) != nil else {
            return Fail(error: HTTPServiceError.HTTPEndpointNotValid).eraseToAnyPublisher()
        }
        
        let jsonData: Data? = """
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
        
        return Just(HTTPServiceResponse(data: jsonData!))
            .setFailureType(to: HTTPServiceError.self)
            .eraseToAnyPublisher()
    }
}
