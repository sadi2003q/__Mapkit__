//
//  DestinationSample.swift
//  __MapKit__
//
//  Created by  Sadi on 16/02/2025.
//

import Foundation
import SwiftData
import MapKit



extension Destination {
    static var sampleDestinations: [Destination] {
        
        
        [
            Destination(
                name: "Moulin Rouge",
                latitude: CLLocationCoordinate2D.moulinRouge.latitude,
                longitude: CLLocationCoordinate2D.moulinRouge.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ),
            Destination(
                name: "Eiffel Tower",
                latitude: CLLocationCoordinate2D.eiffelTower.latitude,
                longitude: CLLocationCoordinate2D.eiffelTower.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ),
            Destination(
                name: "Arc de Triomphe",
                latitude: CLLocationCoordinate2D.arcDeTriomphe.latitude,
                longitude: CLLocationCoordinate2D.arcDeTriomphe.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ),
            Destination(
                name: "Gare du Nord",
                latitude: CLLocationCoordinate2D.gareDuNord.latitude,
                longitude: CLLocationCoordinate2D.gareDuNord.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ),
            Destination(
                name: "Louvre Museum",
                latitude: CLLocationCoordinate2D.louvre.latitude,
                longitude: CLLocationCoordinate2D.louvre.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ),
            Destination(
                name: "Sacré-Cœur",
                latitude: CLLocationCoordinate2D.sacreCoeur.latitude,
                longitude: CLLocationCoordinate2D.sacreCoeur.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ),
            Destination(
                name: "Notre-Dame Cathedral",
                latitude: CLLocationCoordinate2D.notreDame.latitude,
                longitude: CLLocationCoordinate2D.notreDame.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            ),
            Destination(
                name: "Panthéon",
                latitude: CLLocationCoordinate2D.pantheon.latitude,
                longitude: CLLocationCoordinate2D.pantheon.longitude,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        ]
        
        
        
    }
}


