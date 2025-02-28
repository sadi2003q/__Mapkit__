//
//  LocationManager.swift
//  __Mapkit__
//
//  Created by Sadi on 24/02/2025.
//

import SwiftData
import MapKit

/// A data model representing a destination with a name, coordinates, and a list of placemarks.
///
/// The `Destination` class stores information about a specific location,
/// including its name, latitude, longitude, and a collection of associated placemarks.
/// It conforms to `@Model` for use with SwiftData.
///
/// ## Topics
/// - Properties
/// - Initialization
/// - Computed Properties
/// - Preview Data
///
@Model
class Destination {
    
    // MARK: - Properties
    
    /// The name of the destination.
    var name: String
    
    /// The latitude coordinate of the destination. Can be `nil` if not provided.
    var latitude: Double?
    
    /// The longitude coordinate of the destination. Can be `nil` if not provided.
    var longitude: Double?
    
    /// The latitude span of the region around the destination. Can be `nil`.
    var latitudeDelta: Double?
    
    /// The longitude span of the region around the destination. Can be `nil`.
    var longitudeDelta: Double?
    
    /// A list of placemarks associated with this destination.
    ///
    /// This property establishes a **one-to-many** relationship between `Destination` and `MTPlacemark`.
    /// The `@Relationship(deleteRule: .cascade)` ensures that when a destination is deleted,
    /// all associated placemarks are also removed.
    @Relationship(deleteRule: .cascade)
    var placemarks: [MTPlacemark] = []
    
    // MARK: - Initialization
    
    /// Initializes a `Destination` instance with optional coordinate and region span values.
    ///
    /// - Parameters:
    ///   - name: The name of the destination.
    ///   - latitude: The latitude coordinate of the destination. Default is `nil`.
    ///   - longitude: The longitude coordinate of the destination. Default is `nil`.
    ///   - latitudeDelta: The latitude span for defining the visible region. Default is `nil`.
    ///   - longitudeDelta: The longitude span for defining the visible region. Default is `nil`.
    ///
    /// - Returns: A newly initialized `Destination` instance.
    init(name: String, latitude: Double? = nil, longitude: Double? = nil, latitudeDelta: Double? = nil, longitudeDelta: Double? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    // MARK: - Computed Properties
    
    /// The coordinate region of the destination.
    ///
    /// This property computes an `MKCoordinateRegion` if all required values (`latitude`, `longitude`,
    /// `latitudeDelta`, and `longitudeDelta`) are provided. Otherwise, it returns `nil`.
    ///
    /// - Returns: An optional `MKCoordinateRegion` representing the location and span.
    var region: MKCoordinateRegion? {
        if let latitude, let longitude, let latitudeDelta, let longitudeDelta {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        } else {
            return nil
        }
    }
}

// MARK: - Preview Data

extension Destination {
    
    /// Provides a preview `ModelContainer` with sample destination and placemarks.
    ///
    /// This static property creates an in-memory data container containing a sample `Destination`
    /// (Paris) with multiple well-known locations (e.g., Eiffel Tower, Louvre Museum).
    ///
    /// - Returns: A `ModelContainer` with a sample destination and placemarks.
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Destination.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        
        // Sample destination (Paris)
        let paris = Destination(
            name: "Paris",
            latitude: 48.856788,
            longitude: 2.351077,
            latitudeDelta: 0.15,
            longitudeDelta: 0.15
        )
        container.mainContext.insert(paris)
        
        // Sample placemarks in Paris
        var placeMarks: [MTPlacemark] {
            [
                MTPlacemark(name: "Louvre Museum", address: "93 Rue de Rivoli, 75001 Paris, France", latitude: 48.861950, longitude: 2.336902),
                MTPlacemark(name: "Sacré-Coeur Basilica", address: "Parvis du Sacré-Cœur, 75018 Paris, France", latitude: 48.886634, longitude: 2.343048),
                MTPlacemark(name: "Eiffel Tower", address: "5 Avenue Anatole France, 75007 Paris, France", latitude: 48.858258, longitude: 2.294488),
                MTPlacemark(name: "Moulin Rouge", address: "82 Boulevard de Clichy, 75018 Paris, France", latitude: 48.884134, longitude: 2.332196),
                MTPlacemark(name: "Arc de Triomphe", address: "Place Charles de Gaulle, 75017 Paris, France", latitude: 48.873776, longitude: 2.295043),
                MTPlacemark(name: "Gare Du Nord", address: "Paris, France", latitude: 48.880071, longitude: 2.354977),
                MTPlacemark(name: "Notre Dame Cathedral", address: "6 Rue du Cloître Notre-Dame, 75004 Paris, France", latitude: 48.852972, longitude: 2.350004),
                MTPlacemark(name: "Panthéon", address: "Place du Panthéon, 75005 Paris, France", latitude: 48.845616, longitude: 2.345996),
            ]
        }
        
        // Associate placemarks with Paris
        placeMarks.forEach { placemark in
            paris.placemarks.append(placemark)
        }
        
        return container
    }
}
