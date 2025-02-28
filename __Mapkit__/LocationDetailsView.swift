//
//  LocationDetailsView.swift
//  __Mapkit__
//
//  Created by  Sadi on 23/02/2025.
//

import SwiftUI
import MapKit
import SwiftData

struct LocationDetailsView: View {
    
    /// Dismiss Button for Sheet
    @Environment(\.dismiss) private var dismiss
    /// Destination which will be bounded to this view
    var destination: Destination?
    /// this is the Place which the details will be shown
    var selectedPlacemark: MTPlacemark?
    
    
    var onShowRoute: ((MTPlacemark) -> Void)?
    
    
    /// **Variable**
    ///     - name : Assigned to selected place name
    ///     - address : computed property. this will come from mapkit
    ///     - Lookaround scene: this is for MKLookAround scene
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var lookaroundScene: MKLookAroundScene?
    
    
    /// This will trigger the Update button for updating the location within the Destination Variable
    var isChange: Bool {
        guard let selectedPlacemark else { return false }
        return (name != selectedPlacemark.name || address != selectedPlacemark.address)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if destination != nil { View_NoDestination }
                    else { View_withDestination }
                }
                .textFieldStyle(.roundedBorder)
                
                Spacer()
                Button_DismissSheet
            }
            
            View_LookAround
            
            SubView_Location
            Spacer()
        }
        .padding()
        .task(id: selectedPlacemark) {
            await fetchLookAroundPreview() // Immediately fetch Lookaround view when selectedplacemark is not nil
        }
        .onAppear {
            /// ``name`` and ``address``
            if let selectedPlacemark, destination != nil {
                name = selectedPlacemark.name
                address = selectedPlacemark.address
            }
        }
    }
    
    /// will not Automatically assignment name and address from data container to text field
    private var View_NoDestination: some View {
        Group {
            TextField("Name", text: $name)
                .font(.title)
            TextField("address", text: $address, axis: .vertical)
            
            if isChange {
                Button("Update") {
                    selectedPlacemark?.name = name
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    selectedPlacemark?.address = address
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    /// Automatically assignment name and address from data container to text field
    private var View_withDestination: some View {
        Group {
            Text(selectedPlacemark?.name ?? "")
                .font(.title2)
                .fontWeight(.semibold)
            Text(selectedPlacemark?.address ?? "")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing)
        }
    }
    
    /// DismissButton of the view
    private var Button_DismissSheet: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.gray)
        }
    }
    
    /// This will show the Look Around if it is available combining with ``fetchLookAroundPreview()`` function
    private var View_LookAround: some View {
        Group {
            if let lookaroundScene {
                LookAroundPreview(initialScene: lookaroundScene)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(height: 200)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
        }
    }
    
    /// This will Handle Selected Location Within the container
    /// - if There is a bounded Location
    ///     - add into the bounded destination if selected placemark is not within the bounded list
    ///     - remove if the selected placemark is within the bounded list
    /// - if There is no bounded Location
    ///     - Button for open the location in apple map application
    /// - Button for Look Around View
    private var SubView_Location: some View {
        HStack {
            Spacer()
            
            if let destination {
                let inList = (selectedPlacemark != nil && selectedPlacemark?.destination != nil)
                Button {
                    if let selectedPlacemark {
                        if selectedPlacemark.destination == nil {
                            destination.placemarks.append(selectedPlacemark)
                        } else {
                            selectedPlacemark.destination = nil
                        }
                        dismiss()
                    }
                } label: {
                    Label(
                        inList ? "Remove" : "Add",
                        systemImage: inList ? "minus.circle" : "plus.circle"
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(inList ? .red : .green)
                .disabled((name.isEmpty || isChange))
            } else {
                HStack {
                    Button("Open in maps", systemImage: "map") {
                        if let selectedPlacemark {
                            let placemark = MKPlacemark(coordinate: selectedPlacemark.coordinate)
                            let mapItem = MKMapItem(placemark: placemark)
                            mapItem.name = selectedPlacemark.name
                            mapItem.openInMaps()
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    Button("Show Route", systemImage: "location.north") {
                        if let selectedPlacemark {
                            onShowRoute?(selectedPlacemark)
                            dismiss()
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    /// Fetch Look Around Preview from Mapkit
    func fetchLookAroundPreview() async {
        if let selectedPlacemark {
            lookaroundScene = nil
            let lookaroundRequest = MKLookAroundSceneRequest(coordinate: selectedPlacemark.coordinate)
            lookaroundScene = try? await lookaroundRequest.scene
        }
    }
}

#Preview {
    TripMapView()
        .environment(LocationManager())
        .modelContainer(Destination.preview)
}
