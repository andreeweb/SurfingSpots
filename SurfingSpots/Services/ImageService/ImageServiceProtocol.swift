//
//  ImageServiceProtocol.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/24/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol ImageServiceProtocol {
    
    /// It returns an image for the city name passed
    ///
    /// - Returns: City image
    func getImageForCity(city: String) -> AnyPublisher<UIImage, ImageServiceError>
}
