//
//  MapView.swift
//  Solegg
//
//  Created by Ernesto Garza Berrueto on 07/06/25.
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
