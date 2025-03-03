//
//  LocationManager.swift
//  __Mapkit__
//
//  Created by  Sadi on 24/02/2025.
//


import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
    
    
    
    /// Model Container for the Database
    @Environment(\.modelContext) private var modelContext
    
    
    ///  typically used in SwiftUI to control the position and zoom level of a map view
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    
    /// structure used in MapKit to define a region of the map, which includes a canter coordinate (latitude and longitude) and a span (which defines the zoom level).
    @State private var visibleRegion: MKCoordinateRegion?
    
    
    /// **Variable**
    ///     - Search text - For Search Category name
    ///     - SearchFieldFocus - For Focus Related Work on the Field
    @State private var searchText = ""
    @FocusState private var searchFieldFocus: Bool
    
    
    /// All the Location in the Database where Type is MTPlacemark and inside their destination is nil
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil}) private var searchPlacemarks: [MTPlacemark]
    
    
    /// Combination of all those who are In the Database
    private var listPlacemarks: [MTPlacemark] {
        searchPlacemarks + destination.placemarks
    }
    
    
    /// Binding Variable
    /// Camera Position will be based on this Variable
    var destination: Destination
    
    /// Toggle between onTap Locations and Search result Locations
    @State private var isManualMarker = false
    
    
    /// For Selecting Search Result and Showing Details
    @State private var selectedPlacemarks: MTPlacemark?
    

    var body: some View {
        
        VStack {
#warning("Here I am not Sure")
            LabeledContent_CurrentDestinationInformation
            View_AdjustMap
            
        }
        .padding()
        
        // Map reader + onTap gesture --> ontap Location mark
        MapReader { proxy in
            Map(position: $cameraPosition, selection: $selectedPlacemarks) {
                
                ForEach(listPlacemarks) { placemark in
                    if isManualMarker {
                        if placemark.destination != nil {
                            Marker(coordinate: placemark.coordinate) {
                                Label(placemark.name, systemImage: "star")
                            }
                            .tint(.yellow)
                        } else {
                            Marker(placemark.name, coordinate: placemark.coordinate)
                        }
                    } else {
                        Group{
                            if placemark.destination != nil {
                                Marker(coordinate: placemark.coordinate) {
                                    Label(placemark.name, systemImage: "star")
                                }
                                .tint(.yellow)
                            } else {
                                Marker(placemark.name, coordinate: placemark.coordinate)
                            }
                        }.tag(placemark) ///  Here is the Difference
                    }
                    
                }
                
            }
            .onTapGesture { position in
                
                /// when tapping into the Display, if the variable is true then convert the tapped position into coordinate and store that  into the selected Placemark and also storing that into the database so Marker is being initialised to mark the position into the map
                if isManualMarker {
                    if let coordinate = proxy.convert(position
                                                      , from: .local) {
                        let mtPlacemark = MTPlacemark(
                            name: "",
                            address: "",
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                        modelContext.insert(mtPlacemark)
                        selectedPlacemarks = mtPlacemark
                    }
                }
                
            }
        }
        
        .sheet(item: $selectedPlacemarks, onDismiss: {
            if isManualMarker { //remove all marker from model context
                MapManager.removeSearchResults(modelContext)
            }
        } , content: { selectedPlacemrk in // pass the selected placemark into the nextView
            LocationDetailsView(destination: destination, selectedPlacemark: selectedPlacemrk)
                .presentationDetents([.medium])
        })
        .safeAreaInset(edge: .bottom) {
            VStack{
                Button_toggle
                if !isManualMarker {
                    View_Search
                }
            }
            .padding(.horizontal, 30)
        }
        .navigationTitle("Destination")
        .toolbarTitleDisplayMode(.inline)
        .onMapCameraChange(frequency: .onEnd){ context in
            visibleRegion = context.region
        }
        .onAppear {
            MapManager.removeSearchResults(modelContext)
            ///Get region into destination position
            if let region = destination.region {
                cameraPosition = .region(region)
            }
        }
        .onDisappear {
            MapManager.removeSearchResults(modelContext)
        }
    }
    
    /// Toggle Button of ``isManualMarker``
    private var Button_toggle: some View {
        Toggle(isOn: $isManualMarker) {
            Label("Tap marker placement is: \(isManualMarker ? "ON" : "OFF")", systemImage: isManualMarker ? "mappin.circle" : "mappin.slash.circle")
        }
        .fontWeight(.bold)
        .toggleStyle(.button)
        .background(.ultraThinMaterial)
        .onChange(of: isManualMarker) {
            MapManager.removeSearchResults(modelContext)
        }
    }
    
    
    /// Search View with onSubmit action
    private var View_Search: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($searchFieldFocus)
                .overlay(alignment: .trailing) {
                    if searchFieldFocus {
                        Button {
                            searchText = ""
                            searchFieldFocus = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .offset(x: -5)
                    }
                }
                .onSubmit {
                    Task {
                        await MapManager.searchPlaces(
                            modelContext,
                            searchText: searchText,
                            visibleRegion: visibleRegion
                        )
                        searchText = ""
                        cameraPosition = .automatic
                    }
                }
            if !searchPlacemarks.isEmpty {
                Button {
                    MapManager.removeSearchResults(modelContext)
                }label: {
                    Image(systemName: "mappin.slash.circle.fill")
                        .imageScale(.large)
                }
                .foregroundStyle(.white)
                .padding(8)
                .background(.red)
                .clipShape(.circle)
            }
        }
    }
    
    /// Display the Destination Details on the top of view
    private var LabeledContent_CurrentDestinationInformation: some View {
        LabeledContent {
            @Bindable var destination = destination
            TextField(destination.name, text: $destination.name)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(.primary)
        } label: {
            Text("Name: ")
        }
    }
    
    /// Top Bar text for asking user to set the camera position
    private var View_AdjustMap: some View {
        HStack {
            Text("Adjust the map to set the region for your destination.")
                .foregroundStyle(.secondary)
            Spacer()
            Button("Set region") {
                if let visibleRegion {
                    destination.latitude = visibleRegion.center.latitude
                    destination.longitude = visibleRegion.center.longitude
                    destination.latitudeDelta = visibleRegion.span.latitudeDelta
                    destination.longitudeDelta = visibleRegion.span.longitudeDelta
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        DestinationLocationsMapView(destination: destination)
    }
    .modelContainer(Destination.preview)
}
