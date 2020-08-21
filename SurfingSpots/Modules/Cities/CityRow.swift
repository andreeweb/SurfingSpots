//
//  CityRow.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import SwiftUI

struct CityRow: View {
    
    let city: CityWeather
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: city.image)
                .resizable()
                .cornerRadius(15.0)
            VStack(alignment: .leading) {
                Text(city.name)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                HStack {
                    Text(city.weather.rawValue)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                    Text("-")
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                    Text(city.temperature.description)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                    Text("degrees")
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                }
            }.padding()
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 200.0)
            .padding(.bottom, 5)

    }
}

struct CityRow_Previews: PreviewProvider {
    
    static var previews: some View {
    
        let name = "Cuba"
        let image = #imageLiteral(resourceName: "test-image-city")
        let temperature: Float = 28.8
        let weather = WeatherCondition.Cloudy
        
        let city = CityWeather(name: name,
                               image: image,
                               temperature: temperature,
                               weather: weather)
        
        return CityRow(city: city)
    }
}
