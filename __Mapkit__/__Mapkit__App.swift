//
//  __Mapkit__App.swift
//  __Mapkit__
//
//  Created by  Sadi on 22/02/2025.
//

import SwiftUI
import SwiftData


@main
struct __Mapkit__App: App {
    
    @State private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                StartTab()
            } else {
                LocationDeniedView()
            }
        }
        .modelContainer(for: Destination.self)
        .environment(locationManager)
        
    }
}
