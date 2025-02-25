import SwiftUI
import MapKit
import SwiftData

struct TripMapView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var visibleRegion: MKCoordinateRegion?
    @Environment(LocationManager.self) var locationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Query private var listPlacemark: [MTPlacemark]
    
    
    //Search
    @State private var searchText = ""
    @FocusState private var searchFieldFocus: Bool
    
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil}) private var searchPlacemarks: [MTPlacemark]
    
    @State private var selectedPlacemark: MTPlacemark?
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedPlacemark) {
            UserAnnotation{
                AnimatedPositionSymbol()
                    .frame(width: 100, height: 100)
            }
            
            ForEach(listPlacemark, id: \.self) { placemark in
                Group{
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
        }
        .sheet(item: $selectedPlacemark) { selectedPlacemark in
            LocationDetailsView(selectedPlacemark: selectedPlacemark)
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
    
    
}


struct AnimatedPositionSymbol: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Outer pulsing circle
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .scaleEffect(animate ? 1.5 : 1)
                .opacity(animate ? 0 : 1)
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: animate)
            
            // Inner pulsing circle
            Circle()
                .fill(Color.blue.opacity(0.4))
                .frame(width: 30, height: 30)
                .scaleEffect(animate ? 1.2 : 1)
                .opacity(animate ? 0 : 1)
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false).delay(0.5), value: animate)
            
            // Pin symbol
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

#Preview {
    TripMapView()
        .environment(LocationManager())
        .modelContainer(Destination.preview)
    //LocationPinView()
//    AnimatedPositionSymbol()
    
    
}
