//
//  CancellableExtension.swift
//  SurfingSpots
//
//  Created by Andrea Cerra on 9/14/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import Foundation
import Combine

extension AnyCancellable: RequestCancelProtocol {
    
    func cancelMe() {
        self.cancel()
    }
}
