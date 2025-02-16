//
//  MTPlaceMark.swift
//  __MapKit__
//
//  Created by  Sadi on 16/02/2025.
//

import Foundation
import SwiftData
import MapKit

@Model
class MTPlaceMark {
    var name: String
    var address: String
    var longitude: Double
    var latitude: Double
    
    var destination : Destination?
    
    
    init(name: String, address: String, longitude: Double, latitude: Double) {
        self.name = name
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
