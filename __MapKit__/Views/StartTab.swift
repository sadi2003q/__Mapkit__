//
//  StartTab.swift
//  __MapKit__
//
//  Created by  Sadi on 15/02/2025.
//

import SwiftUI

struct StartTab: View {
    var body: some View {
        TabView {
            Group {
                TripMapView()
                    .tabItem {
                        Label("TripMap", systemImage: "map")
                    }
                DestinationLocationsMapView()
                    .tabItem {
                        Label("Destinations", systemImage: "globe.desk")
                    }
            }
            .toolbarBackground(.thickMaterial.opacity(0.1), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}

#Preview {
    StartTab()
}
