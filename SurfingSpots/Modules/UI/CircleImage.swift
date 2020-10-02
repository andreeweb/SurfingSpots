//
//  CircleImage.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 9/13/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("city-cloudy-bg"))
    }
}
