//
//  MapView.swift
//  Solegg
//
//

import SwiftUI
import MapKit

struct MapView: View {
    let viewModel : ContentViewModel
    
    @State private var position: MapCameraPosition = .automatic
    var body: some View {
        MapViewComponent(viewModel: viewModel)
    }
}


#Preview {
    MapView(viewModel: ContentViewModel())
}
