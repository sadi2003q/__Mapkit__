//
//  DestinationsLisView.swift
//  __Mapkit__
//
//  Created by  Sadi on 22/02/2025.
//

import SwiftUI
import SwiftData


struct DestinationsLisView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Destination.name) private var destinations: [Destination]
    @State private var newDestination: Bool = false
    
    @State private var destinationName: String = ""
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !destinations.isEmpty {
                    List(destinations, id: \.self) { destination in
                        NavigationLink(value: destination) {
                        
                                HStack {
                                    Image(systemName: "globe")
                                        .imageScale(.large)
                                        .foregroundStyle(.primary)
                                    VStack(alignment: .leading) {
                                        Text(destination.name)
                                        Text("^[\(destination.placemarks.count) location](inflect: true)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                        }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    modelContext.delete(destination)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        
                    }
                    .navigationDestination(for: Destination.self) { destination in
                        DestinationLocationsMapView(destination: destination)
                    }
                            
                } else {
                    ContentUnavailableView(
                        "No Destination Found",
                        systemImage: "globe.desk",
                        description: Text("NO Destination found Please setup one")
                    )
                }
            }
            .navigationTitle("My Destinations")
            .toolbar {
                Button {
                    newDestination.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .alert(
                    "Enter Destination Name",
                    isPresented: $newDestination) {
                        TextField("Enter destination name", text: $destinationName)
                            .autocorrectionDisabled()
                        Button("OK") {
                            if !destinationName.isEmpty {
                                let destination = Destination(name: destinationName.trimmingCharacters(in: .whitespacesAndNewlines))
                                modelContext.insert(destination)
                                destinationName = ""
                                path.append(destination)
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Create a new destination")
                    }
                
            }
        }
    }
}

#Preview {
    DestinationsLisView()
        .modelContainer(Destination.preview)
}
