//
//  MTPlaceMarkSample.swift
//  __MapKit__
//
//  Created by  Sadi on 16/02/2025.
//

import Foundation
import MapKit
import SwiftData


extension MTPlaceMark {
    static var samplePlaceMarks: [MTPlaceMark] {
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
}
