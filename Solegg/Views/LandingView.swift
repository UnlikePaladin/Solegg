//
//  LandingView.swift
//  Solegg
//
//  Created by Ernesto Garza Berrueto on 07/06/25.
//

import SwiftUI
import MapKit


struct LandingView: View {
    @State private var searchText: String = ""
    var locationManager = CLLocationManager()
    @StateObject var temperatureFetcher = TemperatureFetcher()
    @State private var location: CLLocationCoordinate2D? = nil

    var body: some View {
        
        let apiKey = Bundle.main.infoDictionary?["OpenWeatherApiKey"] as? String ?? "dummy"
        
        NavigationStack {
            
            Text(temperatureFetcher.temperature != nil ? "\(Int(temperatureFetcher.temperature!))°C" : "Loading...")
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(.white)
                .padding(30)
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray.opacity(0.8)))

            
            Image("SoleFeliz").resizable().aspectRatio(contentMode: .fit)
                .padding(CGFloat(20))
        }.padding()
        .searchable(text: $searchText, placement: SearchFieldPlacement.toolbar)
        .onAppear {
            if let coord = CLLocationManager().location?.coordinate {
                self.location = coord
                temperatureFetcher.fetchTemperature(apiKey: apiKey, location: coord)
            }
        }
        
    }
}

#Preview {
    LandingView()
}
