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
    @Published private(set) var loadingMain = true
    @Published private(set) var loadingUpdate = true
    @Published private(set) var showError = false
        
    // https://www.appsdissected.com/save-sink-assign-subscriber-anycancellable/
    var subscription: Cancellable? = nil
    
    /// Dependencies
    var cityService: CityServiceProtocol
    
    init(cityService: CityServiceProtocol) {
        
        self.cityService = cityService
    }
    
    func getCities() {
        
        // reset flags
        loadingMain = true
        showError = false
                
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
                self?.parseData(data: downloadedCities)
            })
    }
    
    private func parseData(data: [City]){
        
        for city in data {
            
            let name = city.name
            let image = #imageLiteral(resourceName: "city-placeholder")
            let temperature: Float = .infinity
            let weather = WeatherCondition.NotAvailable
            
            let city = CityWeather(name: name,
                                   image: image,
                                   temperature: temperature,
                                   weather: weather)
            cities.append(city)
        }
        
        loadingMain = false
        loadingUpdate = false
        showError = false
    }
    
    private func updateData(){
        
    }
    
    private func errorView(){
        
        // reset list data
        cities = []
        
        loadingMain = false
        showError = true
        loadingUpdate = false
    }
    
    deinit {
        subscription?.cancel()
    }
}
