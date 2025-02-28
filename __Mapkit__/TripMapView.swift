import SwiftUI
import MapKit
import SwiftData

///
///  TripMapView.swift
///
///  ## TripMapView
///  An interactive map view for managing trip locations, searching for places,
///  and displaying routes using `MapKit` and `SwiftData`.
///
///  ### Features:
///  - Displays user location with animated marker
///  - Shows saved placemarks and highlights destinations
///  - Provides a search bar for finding locations
///  - Calculates and displays routes between user and a selected destination
///
///  This view integrates with `LocationManager` to track user movement and
///  `MapManager` to handle search queries and route calculations.
///
///  Created by Adnan
///
struct TripMapView: View {
    /// The shared model context for data persistence.
    @Environment(\ .modelContext) private var modelContext
    
    /// The visible region of the map.
    @State private var visibleRegion: MKCoordinateRegion?
    
    /// The location manager to track user location.
    @Environment(LocationManager.self) var locationManager
    
    /// The camera position of the map, initially set to user location.
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    /// List of placemarks stored in the database.
    @Query private var listPlacemark: [MTPlacemark]
    
    // MARK: - Search Properties
    
    /// The search query text.
    @State private var searchText = ""
    
    /// Focus state for the search field.
    @FocusState private var searchFieldFocus: Bool
    
    /// List of placemarks that are not yet set as a destination.
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil}) private var searchPlacemarks: [MTPlacemark]
    
    /// The selected placemark from search results.
    @State private var selectedPlacemark: MTPlacemark?
    
    // MARK: - Route Properties
    
    /// The computed route from the user location to the selected placemark.
    @State private var route: MKRoute?
    
    /// A flag to determine whether to show the route.
    @State private var showRoute = false
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedPlacemark) {
            UserAnnotation {
                AnimatedPositionSymbol()
                    .frame(width: 100, height: 100)
            }
            
            ForEach(listPlacemark, id: \ .self) { placemark in
                Group {
                    if placemark.destination != nil {
                        Marker(coordinate: placemark.coordinate) {
                            Label(placemark.name, systemImage: "star")
                        }
                        .tint(.yellow)
                    } else {
                        Marker(placemark.name, coordinate: placemark.coordinate)
                    }
                }.tag(placemark)
            }
            
            if let route = route, showRoute {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .sheet(item: $selectedPlacemark) { selectedPlacemark in
            LocationDetailsView(
                selectedPlacemark: selectedPlacemark,
                onShowRoute: { placemark in
                    Task {
                        await calculateRoute(to: placemark)
                        showRoute = true
                    }
                }
            )
            .presentationDetents([.height(450)])
        }
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            updateCameraPosition()
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                VStack {
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
                            }
                        }
                }
                .padding()
                VStack {
                    if !searchPlacemarks.isEmpty {
                        Button {
                            MapManager.removeSearchResults(modelContext)
                        } label: {
                            Image(systemName: "mappin.slash")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                .padding()
                .buttonBorderShape(.circle)
            }
        }
    }
    
    /// Updates the camera position based on the user's current location.
    func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
    
    /// Calculates and updates the route to a given placemark.
    /// - Parameter placemark: The destination placemark.
    private func calculateRoute(to placemark: MTPlacemark) async {
        guard let userLocation = locationManager.userLocation else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: placemark.coordinate))
        request.transportType = .automobile
        
        do {
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            if let firstRoute = response.routes.first {
                route = firstRoute
                let routeRegion = firstRoute.polyline.boundingMapRect
                cameraPosition = .rect(MKMapRect(
                    x: routeRegion.origin.x - routeRegion.size.width * 0.2,
                    y: routeRegion.origin.y - routeRegion.size.height * 0.2,
                    width: routeRegion.size.width * 1.4,
                    height: routeRegion.size.height * 1.4
                ))
            }
        } catch {
            print("Error calculating route: \(error)")
        }
    }
}

/// An animated symbol to represent the user's current location.
struct AnimatedPositionSymbol: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .scaleEffect(animate ? 1.5 : 1)
                .opacity(animate ? 0 : 1)
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: animate)
            
            Circle()
                .fill(Color.blue.opacity(0.4))
                .frame(width: 30, height: 30)
                .scaleEffect(animate ? 1.2 : 1)
                .opacity(animate ? 0 : 1)
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false).delay(0.5), value: animate)
            
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.blue)
                .shadow(radius: 5)
        }
        .onAppear {
            animate = true
        }
    }
}
