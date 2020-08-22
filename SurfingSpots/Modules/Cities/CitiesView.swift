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
                        Text("Error")
                        Spacer().frame(height: 15)
                        Button(action: {
                            self.viewModel.getCities()
                        }){
                            Text("Tap Here")
                        }
                    }
                    .navigationBarTitle(Text("Surfing Spots"))
                    
                } else {
                    
                    List(viewModel.cities) { data in
                        CityRow(city: data)
                    }
                    .navigationBarTitle(Text("Surfing Spots"))
                    .navigationBarItems(trailing:
                        ActivityIndicator(isAnimating: .constant(viewModel.loadingUpdate),
                                          color: .constant(UIColor.gray),
                                          style: .medium)
                    )
                    
                    ActivityIndicator(isAnimating: .constant(viewModel.loadingMain),
                                      color: .constant(UIColor.gray),
                                      style: .large)
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
        CitiesView(viewModel: CitiesViewModel(cityService: CityServiceMock()))
    }
}
