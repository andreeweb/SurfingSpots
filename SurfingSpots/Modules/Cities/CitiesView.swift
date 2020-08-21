//
//  ContentView.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import SwiftUI

struct CitiesView: View {
    
    var body: some View {
        
        UITableView.appearance().separatorStyle = .none

        let name = "Cuba"
        let image = #imageLiteral(resourceName: "test-image-city")
        let temperature: Float = 28.8
        let weather = WeatherCondition.Cloudy
        
        let city = CityWeather(name: name,
                               image: image,
                               temperature: temperature,
                               weather: weather)
        
        let city2 = CityWeather(name: name,
                                image: image,
                                temperature: temperature,
                                weather: weather)
        
        let city3 = CityWeather(name: name,
                                image: image,
                                temperature: temperature,
                                weather: weather)
        
        let modelData = [city, city2, city3]
        
        return NavigationView {
            List(modelData) { data in
                CityRow(city: data)
            }.navigationBarTitle(Text("Surfing Spots"))
            .foregroundColor(Color.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView()
    }
}
