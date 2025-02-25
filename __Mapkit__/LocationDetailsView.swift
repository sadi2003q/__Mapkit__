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
    
    @Environment(\.dismiss) private var dismiss
    
    var destination: Destination?
    var selectedPlacemark: MTPlacemark?
    
    @State private var name: String = ""
    @State private var address: String = ""
    
    @State private var lookaroundScene : MKLookAroundScene?
    
    var isChange: Bool {
        guard let selectedPlacemark else { return false }
        
        return (name != selectedPlacemark.name || address != selectedPlacemark.address)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if destination != nil {
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
                    } else {
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
                .textFieldStyle(.roundedBorder)
                
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
               
            }
            if let lookaroundScene {
                            LookAroundPreview(initialScene: lookaroundScene)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(height: 200)
                                .padding()
                        } else {
                            ContentUnavailableView("No preview available", systemImage: "eye.slash")
                        }
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
                            systemImage: inList ? "minum.circle" : "plus.circle"
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
                            
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }
                    .buttonStyle(.bordered)
                }
            }
            Spacer()
        }
        .padding()
        .task(id: selectedPlacemark) {
            await fetchLookAroundPreview()
        }
            .onAppear {
                if let selectedPlacemark, destination != nil {
                    name = selectedPlacemark.name
                    address = selectedPlacemark.address
                }
            }
    }
    
    func fetchLookAroundPreview() async {
        if let selectedPlacemark {
            lookaroundScene = nil
            let lookaroundRequest = MKLookAroundSceneRequest(coordinate: selectedPlacemark.coordinate)
            lookaroundScene = try? await lookaroundRequest.scene
        }
    }
    
    
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    let selectedPlacemark = destination.placemarks[0]
    return LocationDetailsView(
        destination: destination,
        selectedPlacemark: selectedPlacemark
    )
}
