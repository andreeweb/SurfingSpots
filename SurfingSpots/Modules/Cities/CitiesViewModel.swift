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
    @Published private(set) var loading = false
    @Published private(set) var showError = false
        
    // https://www.appsdissected.com/save-sink-assign-subscriber-anycancellable/
    private var subscription: Cancellable? = nil
    private var weatherSubscriptions: [Cancellable] = []
    
    // timer for the weather and temperature update
    private var updateTimer: Timer?
    private let updateTime: Double = 3.0
    
    // Dependencies
    private let cityService: CityServiceProtocol
    private let weatherService: WeatherServiceProtocol
    
    init(cityService: CityServiceProtocol,
         weatherService: WeatherServiceProtocol) {
        
        self.cityService = cityService
        self.weatherService = weatherService
    }
    
    /// It updates the @Published cities array exposed from this ViewModel
    ///
    func getCities() {
        
        showError = false
        loading = true
                    
        subscription = cityService.getCities().sink(
            receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .finished:
                    self?.startUpdate()
                    break
                case .failure(let error):
                    print(error)
                    self?.errorView()
                }
            }, receiveValue: { [weak self] (downloadedCities) in
                self?.parseData(data: downloadedCities)
            })
    }
    
    /// It starts the local timer used for update the city weather.
    /// See also the updateData() method
    ///
    private func startUpdate(){
        
        // schedule timer for next update
        updateTimer = Timer.scheduledTimer(timeInterval: updateTime,
                                           target: self,
                                           selector: #selector(updateData),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    /// It parses the [City] array retrieved from the CityService
    /// transforming the City model to CityWeather.
    /// It also updates the local cities array that will cause a View update
    ///
    private func parseData(data: [City]){
        
        for city in data {
            
            let name = city.name
            let image = #imageLiteral(resourceName: "city-placeholder")
            let temperature: Float = .infinity
            let weather = WeatherCondition.NotAvailable
            
            let cityWeather = CityWeather(name: name,
                                          image: image,
                                          temperature: temperature,
                                          weather: weather,
                                          isLoadingImage: false,
                                          isLoadingWeather: true)
            cities.append(cityWeather)
            
            // download the weather
            updateWeather(for: cityWeather)
        }
        
        loading = false
        showError = false
    }
    
    /// It requests a weather update for a specific city.
    /// This method will call updateCityWithNewWeather or updateCityWithNoWeatherData
    /// that will cause a view update.
    private func updateWeather(for city: CityWeather){

        // update in progress
        loading = true
        
        let sub = weatherService.getWeatherForCity(city: city.name).sink(
            receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self?.updateCityWithNoWeatherData(city: city)
                }
            
            }, receiveValue: { [weak self] (weatherData) in
                
                self?.updateCityWithNewWeather(weatherData: weatherData,
                                               city: city)
                
                self?.loading = false
            })
        
        weatherSubscriptions.append(sub)
    }
    
    /// It updates the weather data for a specific city.
    /// It also updates the local cities array that will cause a View update
    ///
    private func updateCityWithNewWeather(weatherData: WeatherData,
                                          city: CityWeather) {
        
        var weather = WeatherCondition.NotAvailable
        var backgroundImage = #imageLiteral(resourceName: "city-placeholder")
        
        if weatherData.temperature >= 30.0 {
            
            weather = .Sunny
            // download the image!! only in this case TBD
            
        }else{
            
            weather = .Cloudy
            backgroundImage = #imageLiteral(resourceName: "city-cloudy-bg")
        }
        
        let cityWeatherUpdated =  CityWeather(name: city.name,
                                              image: backgroundImage,
                                              temperature: Float(weatherData.temperature),
                                              weather: weather,
                                              isLoadingImage: city.isLoadingImage,
                                              isLoadingWeather: false)
        
        updateCityInList(oldCity: city,
                         updatedCity: cityWeatherUpdated)
    }
    
    /// It updates the specifc city with No-Weather information
    /// It also updates the local cities array that will cause a View update
    ///
    private func updateCityWithNoWeatherData(city: CityWeather) {
        
        let cityWeatherUpdated = CityWeather(name: city.name,
                                             image: city.image,
                                             temperature: .infinity,
                                             weather: WeatherCondition.NotAvailable,
                                             isLoadingImage: city.isLoadingImage,
                                             isLoadingWeather: false)
        
        updateCityInList(oldCity: city,
                         updatedCity: cityWeatherUpdated)
    }
    
    /// It replaces (in order to force the update) in the cities array the CityWeather passed
    /// with a new CityWeather model. This new model should contains new data or updates
    /// for the city.
    ///
    private func updateCityInList(oldCity: CityWeather,
                                  updatedCity: CityWeather){
        
        // replace in the array
        if let i = cities.firstIndex(where: { $0.name == oldCity.name }) {
            cities[i] = updatedCity
        }
        
        reorderList()
    }
    
    /// It download/retrieve the image for the selected city.
    /// this method will cause a view update.
    ///
    private func updateCityImage(for city: CityWeather){
        
        
    }
    
    /// It encapsulete the logic for reorder the cities array in order to have
    /// cities from the hottest to the coolest.
    ///
    private func reorderList(){
        
        cities.sort {
            $0.temperature > $1.temperature
        }
    }
    
    /// It encapsulate the logic for random update the weather.
    ///
    @objc private func updateData(){
        
        loading = true
        
        // get random index
        let randomIndex = Int.random(in: 0..<cities.count)
        
        // get city
        let city = cities[randomIndex]
        
        // update
        updateWeather(for: city)
    }
    
    /// It sets the flags used for show the error view.
    ///
    private func errorView(){
        
        // reset list data
        cities = []
        
        showError = true
        loading = false
    }
    
    deinit {
        
        subscription?.cancel()
        updateTimer?.invalidate()
        
        for sub in weatherSubscriptions {
            sub.cancel()
        }
    }
}
