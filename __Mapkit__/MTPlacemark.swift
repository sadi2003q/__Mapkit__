//
//  MTPlacemark.swift
//  __Mapkit__
//
//  Created by Sadi on 23/02/2025.
//

import SwiftData
import MapKit

/// A data model representing a geographic location with name, address, and coordinates.
///
/// The `MTPlacemark` class is used to store and manage information about a specific place,
/// including its name, address, latitude, longitude, and an optional destination reference.
/// It conforms to `@Model` for use with SwiftData.
///
/// ## Topics
/// - Properties
/// - Initialization
/// - Computed Properties
///
@Model
class MTPlacemark {
    
    // MARK: - Properties
    
    /// The name of the place.
    var name: String
    
    /// The formatted address of the place.
    var address: String
    
    /// The latitude coordinate of the place.
    var latitude: Double
    
    /// The longitude coordinate of the place.
    var longitude: Double
    
    /// An optional reference to a `Destination` object associated with this placemark.
    var destination: Destination?
    
    // MARK: - Initialization
    
    /// Initializes an `MTPlacemark` instance with the given details.
    ///
    /// - Parameters:
    ///   - name: The name of the place.
    ///   - address: The formatted address of the place.
    ///   - latitude: The latitude coordinate of the place.
    ///   - longitude: The longitude coordinate of the place.
    ///
    /// - Returns: A newly initialized `MTPlacemark` instance.
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Computed Properties
    
    /// The coordinate of the place as a `CLLocationCoordinate2D` object.
    ///
    /// This property provides a convenient way to access the latitude and longitude
    /// as a `CLLocationCoordinate2D` type for use with `MapKit`.
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
