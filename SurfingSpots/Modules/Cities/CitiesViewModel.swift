//
//  CitiesViewModel.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine
import UIKit

final class CitiesViewModel: ObservableObject {
    
    @Published private(set) var cities: [CityWeather] = []
    @Published private(set) var loading = true
    @Published private(set) var showError = true
        
    // https://www.appsdissected.com/save-sink-assign-subscriber-anycancellable/
    var subscription: Cancellable? = nil
    
    /// Dependencies
    var cityService: CityServiceProtocol
    
    init(cityService: CityServiceProtocol) {
        
        self.cityService = cityService
    }
    
    func getCities() {
        
        // reset flags
        self.loading = true
        self.showError = false
                
        subscription = cityService.getCities().sink(
            receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self?.errorView()
                }
            }, receiveValue: { [weak self] (downloadedCities) in
                self?.parseData(cities: downloadedCities)
            })
    }
    
    private func parseData(cities: [City]){
        
        for city in cities {
            
            let name = city.name
            let image = #imageLiteral(resourceName: "test-image-city")
            let temperature: Float = 28.8
            let weather = WeatherCondition.Cloudy
            
            let city = CityWeather(name: name,
                                   image: image,
                                   temperature: temperature,
                                   weather: weather)
            self.cities.append(city)
        }
        
        self.loading = false
    }
    
    private func errorView(){
        
        self.loading = false
        self.showError = true
    }
    
    deinit {
        subscription?.cancel()
    }
}
