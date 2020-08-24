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
                Spacer().frame(height: 5)
                
                HStack {
                    
                    if (city.isLoadingImage || city.isLoadingWeather) {
                        
                        ActivityIndicator(isAnimating: .constant(true),
                                          color: .constant(UIColor.gray),
                                          style: .medium)
                        
                    }else{
                        
                        Text(city.weather.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                    }
                    
                    if city.temperature == .infinity {
                        
                        Text(LocalizedStringKey("temperature_placeholder"))
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                                                
                    }else{
                        
                        Text("-")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                        
                        Text(city.temperature.description)
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                        
                        Text(LocalizedStringKey("degrees_string"))
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                    }
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
        let image = #imageLiteral(resourceName: "city-placeholder")
        let temperature: Float = 28.8
        let weather = WeatherCondition.Sunny
        
        let city = CityWeather(name: name,
                               image: image,
                               temperature: temperature,
                               weather: weather,
                               isLoadingImage: false,
                               isLoadingWeather: false)
        
        return CityRow(city: city)
    }
}
