//
//  HTTPServiceError.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation

enum HTTPServiceError: Error {
    case HTTPRequestError(reason: String)
    case HTTPResponseError
    case HTTPEndpointNotValid
    case HTTPError(statusCode: Int)
}
