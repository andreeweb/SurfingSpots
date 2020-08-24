//
//  ImageService.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/24/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ImageService: ImageServiceProtocol {

    // HTTP Service Class for make HTTP requests
    private var httpService: HTTPServiceProtocol
    
    init(httpService: HTTPServiceProtocol) {
        self.httpService = httpService
    }
    
    func getImageForCity(city: String) -> AnyPublisher<UIImage, ImageServiceError> {
        
        let url = ImageServiceConfig.cityImagesEndpoint
        
        return httpService.makeHttpRequest(endpoint: url)
            .mapError { _ in return ImageServiceError.ImageRequestError }
            .tryMap { httpRespose in

                if let image = UIImage(data: httpRespose.data) {
                    return image
                }else{
                    throw ImageServiceError.ImageNotAvailable
                }
            }
            .mapError { error in return error as! ImageServiceError }
            .eraseToAnyPublisher()
    }
}
