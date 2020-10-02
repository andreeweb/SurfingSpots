//
//  CitiesDetailView.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 9/13/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import SwiftUI

struct CitiesDetailView: View {
    
    var cityWeather: CityWeather
    // @ObservedObject var viewModel: CitiesDetailViewModel
    
    var body: some View {
        
        VStack {
            
            CircleImage(image: Image(uiImage: cityWeather.image))
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text(cityWeather.name)
                    .font(.title)
            }
            .padding()
            
            Spacer()
        }        
    }
}

struct CitiesDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let cityWeather = CityWeather(name: "Test",
                                      image: #imageLiteral(resourceName: "city-placeholder"),
                                      temperature: 33.4,
                                      weather: WeatherCondition.Sunny,
                                      isLoadingImage: false,
                                      isLoadingWeather: false)
                
        return CitiesDetailView(cityWeather: cityWeather)
    }
}
