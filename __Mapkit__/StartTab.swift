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
                DestinationsLisView()
                    .tabItem {
                        Label("Destinations", systemImage: "globe.desk")
                    }
            }
            .toolbarBackground(.blue.opacity(0.8), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}


#Preview {
    StartTab()
        .modelContainer(Destination.preview)
        .environment(LocationManager())
}
