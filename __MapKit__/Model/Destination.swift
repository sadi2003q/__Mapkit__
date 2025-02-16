//
//  Destination.swift
//  __MapKit__
//
//  Created by  Sadi on 16/02/2025.
//

import Foundation
import SwiftData
import MapKit


@Model
class Destination {
    var name: String
    var latitude: Double?
    var longitude: Double?
    var latitudeDelta: Double?
    var longitudeDelta: Double?
    
    @Relationship(deleteRule: .cascade)
    var placeMark: [MTPlaceMark] = []
    //var placeMark: [MTPlaceMark]?
    
    
    init(
        name: String,
        latitude: Double?,
        longitude: Double?,
        latitudeDelta: Double?,
        longitudeDelta: Double?,
        placeMark : [MTPlaceMark]? = nil
    ) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
        //self.placeMark = placeMark
    }
    
    
    var region : MKCoordinateRegion? {
        if let latitude, let longitude, let latitudeDelta, let longitudeDelta  {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        } else {
            return nil
        }
    }
    
}



extension Destination {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Destination.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
//        let paris = CLLocationCoordinate2D(latitude: 48.856788, longitude: 2.351077)
//        let parisSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let paris = Destination(
            name: "Paris",
            latitude: 48.856788,
            longitude: 2.351077,
            latitudeDelta: 0.15,
            longitudeDelta: 0.15
        )
        container.mainContext.insert(paris)
        var placeMarks: [MTPlaceMark] {
            [
                MTPlaceMark(name: "Louvre Museum", address: "93 Rue de Rivoli, 75001 Paris, France", longitude: 2.336902, latitude: 48.861950),
                MTPlaceMark(name: "Sacré-Coeur Basilica", address: "Parvis du Sacré-Cœur, 75018 Paris, France", longitude: 2.343048, latitude: 48.886634),
                MTPlaceMark(name: "Eiffel Tower", address: "5 Avenue Anatole France, 75007 Paris, France", longitude: 2.294488, latitude: 48.858258),
                MTPlaceMark(name: "Moulin Rouge", address: "82 Boulevard de Clichy, 75018 Paris, France", longitude: 2.332196, latitude: 48.884134),
                MTPlaceMark(name: "Arc de Triomphe", address: "Place Charles de Gaulle, 75017 Paris, France", longitude: 2.295043, latitude: 48.873776),
                MTPlaceMark(name: "Gare Du Nord", address: "Paris, France", longitude: 2.354977, latitude: 48.880071),
                MTPlaceMark(name: "Notre Dame Cathedral", address: "6 Rue du Cloître Notre-Dame, 75004 Paris, France", longitude: 2.350004, latitude: 48.852972),
                MTPlaceMark(name: "Panthéon", address: "Place du Panthéon, 75005 Paris, France", longitude: 2.345996, latitude: 48.845616),
            ]
        }
        placeMarks.forEach {placemark in
            paris.placeMark.append(placemark)
        }
        return container
    }
}
