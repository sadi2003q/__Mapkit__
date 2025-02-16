//
//  DestinationLocationsMapView.swift
//  __MapKit__
//
//  Created by  Sadi on 15/02/2025.
//

import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    @Query private var destinations: [Destination]
    @State private var destination: Destination?
    
    var body: some View {
        Map_Content
            .onAppear{
                destination = destinations.first
                if let region = destination?.region {
                    cameraPosition = .region(region)
                }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                visibleRegion = context.region
            }
    }
    
    
    private var Map_Content: some View {
        Map(position: $cameraPosition) {
            if let destination {
                ForEach(destination.placeMark) { placemark in
                    Marker(coordinate: placemark.coordinate) {
                        Label(placemark.name, systemImage: "mappin.circle.fill")
                    }
                }
            }
        }
    }
}
/*
#Preview {
    let preview = Preview(Destination.self)
    
    let placeMarks = MTPlaceMark.samplePlaceMarks
    let destination = Destination.sampleDestinations[0]
    
    let newDestination = Destination(name: destination.name, latitude: destination.latitude, longitude: destination.longitude, latitudeDelta: destination.latitudeDelta, longitudeDelta: destination.longitudeDelta, placeMark: placeMarks)
    
    preview.addExamples([destination])
    return DestinationLocationsMapView()
            .modelContainer(preview.container)
}
*/

#Preview{
    DestinationLocationsMapView()
        .modelContainer(Destination.preview)
}




