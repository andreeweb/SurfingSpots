//
//  ImageServiceMock.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/24/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ImageServiceMock: ImageServiceProtocol {
    
    func getImageForCity(city: String) -> AnyPublisher<UIImage, ImageServiceError> {
        
        return Just(UIImage(imageLiteralResourceName: "city-placeholder"))
            .setFailureType(to: ImageServiceError.self)
            .eraseToAnyPublisher()
    }
}
