//
//  MapManager.swift
//  __Mapkit__
//
//  Created by  Sadi on 23/02/2025.
//

import Foundation
import SwiftData
import MapKit


enum MapManager {
    
    /// Search Function
    /// - Parameters:
    ///   - modelContext: Database container
    ///   - searchText: search text from the user
    ///   - visibleRegion: area within the search will be conducted
    /// - **Method**:
    ///     - make a request variable of MkLocalSearch ``request``
    ///     - set visible natural language property to the  request variable
    ///     - apply region to the visible region if it is available for the option
    ///     - apply search
    ///     - assign search result to ``searchItems`` variable
    ///     - assign mapItem from searchItems to ``result``
    ///     - run a loop on the result then make MTPlacemark item for each result item and assign into the database
    @MainActor
    static func searchPlaces(_ modelContext: ModelContext, searchText: String, visibleRegion: MKCoordinateRegion?) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        if let visibleRegion = visibleRegion {
            request.region = visibleRegion
        }
        
        let searchItems = try? await MKLocalSearch(request: request).start()
        let result = searchItems?.mapItems ?? []
        
        result.forEach {
            let mtPlacemark = MTPlacemark(
                name: $0.placemark.name ?? "",
                address: $0.placemark.title ?? "",
                latitude: $0.placemark.coordinate.latitude,
                longitude: $0.placemark.coordinate.longitude
            )
            modelContext.insert(mtPlacemark)
        }
        
    }
    
    
    
    /// To Remove all search result from the data container
    /// - Parameter modelContext: database container
    static func removeSearchResults(_ modelContext: ModelContext) {
        let searchPredicate = #Predicate<MTPlacemark> { $0.destination == nil }
        try? modelContext.delete(model: MTPlacemark.self, where: searchPredicate)
    }
}
