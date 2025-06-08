//
//  SearchCompleter.swift
//  Solegg
//
//  Created by Ernesto Garza Berrueto on 08/06/25.
//

import SwiftUI
//
//  SearchCompleter.swift
//  Solegg
//
//

import Foundation
import MapKit
import SwiftUI

class LocationSearchCompleter: MKLocalSearchCompleter, ObservableObject {
    @Published var suggestions: [MKLocalSearchCompletion] = []

    override init() {
        super.init()
        self.delegate = self
        self.resultTypes = [.address, .pointOfInterest] // ✅ ADD THIS LINE
    }
}

extension LocationSearchCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.suggestions = completer.results
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}
