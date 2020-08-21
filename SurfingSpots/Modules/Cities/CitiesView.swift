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
                List(viewModel.cities) { data in
                    CityRow(city: data)
                }.navigationBarTitle(Text("Surfing Spots"))
                    .foregroundColor(Color.gray)
            }.onAppear {
                self.viewModel.getCities()
            }
            
            ActivityIndicator(isAnimating: .constant(viewModel.loading),
                              style: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView(viewModel: CitiesViewModel(cityService: CityServiceMock()))
    }
}
