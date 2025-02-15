//
//  DestinationLocationsMapView.swift
//  __MapKit__
//
//  Created by  Sadi on 15/02/2025.
//

import SwiftUI
import MapKit


struct DestinationLocationsMapView: View {
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    
    var body: some View {
        Map_Content
            .onAppear {
                let paris = CLLocationCoordinate2D(latitude: 48.856788, longitude: 2.351077)
                let parisSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let parisRegion = MKCoordinateRegion(center: paris, span: parisSpan)
                
                cameraPosition = .region(parisRegion)
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                visibleRegion = context.region
            }
    }
    
    
    private var Map_Content: some View {
        Map(position: $cameraPosition) {
            Marker("Eiffel Tower", systemImage: "building.circle", coordinate: .eiffelTower)
                .tint(.green)
        }
    }
}

#Preview {
    DestinationLocationsMapView()
}
