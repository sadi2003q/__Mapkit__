//
//  DestinationsLisView.swift
//  __Mapkit__
//
//  Created by  Sadi on 22/02/2025.
//

import SwiftUI
import SwiftData


/// To show all the destination store in to the database.
struct DestinationsLisView: View {
    
    /// Model container for the Data container
    @Environment(\.modelContext) private var modelContext
    
    /// This is for Fetching the Data into the Data container which are Destination type
    /// - to store the show the Data into list format.
    @Query(sort: \Destination.name) private var destinations: [Destination]
    
    
    /// **Variable**
    ///     - `newDestination` to toggle this sheet for storing making new Destination
    ///     - `destinationName` name of the new Destination
    @State private var newDestination: Bool = false
    @State private var destinationName: String = ""
    
    
    /// To Navigate with Specific Type
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !destinations.isEmpty {
                    
                    /// Location Information
                    List_LocationDetails
                    
                    /// Navigate to the New View with Destination
                    .navigationDestination(for: Destination.self) { destination in
                        DestinationLocationsMapView(destination: destination)
                    }
                    
                } else {
                    /// if No Data found in Data Container
                    ContentNotAvailable
                }
            }
            .navigationTitle("My Destinations")
            .toolbar {
                
                
                ///Button for Adding new Destination
                Button_NewDestination
                
                /// New Destination Information
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
    
    private var List_LocationDetails: some View {
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
    }
    
    private var ContentNotAvailable: some View {
        ContentUnavailableView(
            "No Destination Found",
            systemImage: "globe.desk",
            description: Text("NO Destination found Please setup one")
        )
    }
    
    private var Button_NewDestination: some View {
        Button {
            newDestination.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
        }
    }
    
}

#Preview {
    DestinationsLisView()
        .modelContainer(Destination.preview)
}
