//
//  ContentView.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import SwiftUI

struct CitiesView: View {
    
    @ObservedObject var viewModel: CitiesViewModel
    
    var body: some View {
        
        // Style setup for the view
        UITableView.appearance().separatorStyle = .none
                
        return ZStack {
            
            NavigationView {
                
                if viewModel.showError {
                
                    VStack{
                        Text(LocalizedStringKey("data_not_available"))
                        Spacer().frame(height: 15)
                        Button(action: {
                            self.viewModel.getCities()
                        }){
                            Text(LocalizedStringKey("tap_to_try_again"))
                        }
                    }
                    .navigationBarTitle(Text(LocalizedStringKey("app_name_navigation_bar")))
                    
                } else {
                    
                    List(viewModel.cities) { data in
                        CityRow(city: data)
                    }
                    .animation(.spring())
                    .navigationBarTitle(Text(LocalizedStringKey("app_name_navigation_bar")))
                    .navigationBarItems(trailing:
                        ActivityIndicator(isAnimating: .constant(viewModel.loading),
                                          color: .constant(UIColor.gray),
                                          style: .medium)
                    )
                }
                
            }.onAppear {
                
                // request data from the view model
                self.viewModel.getCities()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView(viewModel: CitiesViewModel(cityService: CityServiceMock(),
                                              weatherService: WeatherServiceMock(),
                                              imageService: ImageServiceMock()))
    }
}
