//
//  LandingView.swift
//  Solegg
//
//

import SwiftUI
import MapKit

struct LandingView: View {
    @State private var searchText: String = ""
    var locationManager = CLLocationManager()
    @StateObject var temperatureFetcher = TemperatureFetcher()
    @State private var location: CLLocationCoordinate2D? = nil
    @State private var locationName: String? = nil
    @StateObject private var searchCompleter = LocationSearchCompleter()
    @State private var animatedBackgroundColor: Color = .blue

    var body: some View {
        let apiKey = Bundle.main.infoDictionary?["OpenWeatherApiKey"] as? String ?? "dummy"

        let temperature = temperatureFetcher.temperature
        let imageName: String = {
            guard let temp = temperature else { return "SoleCargando" }
            switch temp {
            case let t where t > 38: return "SoleFrito"
            case 30...: return "SoleCaliente"
            default: return "SoleFeliz"
            }
        }()
        
        var backgroundColor: Color {
            guard let temp = temperature else { return .black }
            switch temp {
            case let t where t > 38: return .red
            case 30...: return .yellow
            case 0...: return .green
            default: return .blue
            }
        }
    
        
        ZStack {

            
            NavigationStack {
                ZStack {
                    animatedBackgroundColor.opacity(0.5).ignoresSafeArea()

                    VStack(spacing: 16) {
                        Spacer().frame(height: 30)
                        
                        Text(temperature != nil ? "\(Int(temperature!))°C" : "Loading...")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.white)
                            .padding(25)
                            .frame(minWidth: 250)
                            .background(RoundedRectangle(cornerRadius: 30).fill(animatedBackgroundColor.opacity(0.8)))
                            .shadow(radius: 5)
                        
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                            .shadow(radius: 8)
                        
                        if let name = locationName {
                            Text(name)
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .searchable(text: $searchText, placement: .toolbar, prompt: "Search for a city")
                    .onSubmit(of: .search) {
                        // Fallback search if user presses return
                        if let first = searchCompleter.suggestions.first {
                            performSearch(completion: first, apiKey: apiKey)
                            searchText = ""
                        }
                    }
                    .onAppear {
                        if let coord = CLLocationManager().location?.coordinate {
                            updateLocationAndWeather(coord, apiKey: apiKey)
                        }
                        
                        if let temp = temperatureFetcher.temperature {
                              animatedBackgroundColor = {
                                  switch temp {
                                  case let t where t > 38: return .red
                                  case 30...: return .yellow
                                  case 0...: return .green
                                  default: return .blue
                                  }
                              }()
                          }
                    }
                }
                }
                
                
                // Suggestions floating list
                if !searchText.isEmpty && !searchCompleter.suggestions.isEmpty {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 60)
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(searchCompleter.suggestions, id: \.self) { suggestion in
                                    Button(action: {
                                        searchText = ""
                                        performSearch(completion: suggestion, apiKey: apiKey)
                                    }) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(suggestion.title)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                    }
                                    Divider()
                                }
                            }
                            .background(Color(animatedBackgroundColor).brightness(-0.01))
                        }.shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                    }
            }

        }
        .task(id: searchText) {
            searchCompleter.queryFragment = searchText
        }.onChange(of: temperatureFetcher.temperature) { newTemp in
            if let newTemp {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedBackgroundColor = {
                        switch newTemp {
                        case let t where t > 38: return .red
                        case 30...: return .yellow
                        case 0...: return .green
                        default: return .blue
                        }
                    }()
                }
            }
        }
    }
    func performSearch(completion: MKLocalSearchCompletion, apiKey: String) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)

        print("🔎 Performing search for: \(completion.title), \(completion.subtitle)")

        search.start { response, error in
            if let error = error {
                print("❌ Search failed: \(error.localizedDescription)")
            }

            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                print("❗️Location not found in response")
                return
            }

            print("✅ Found coordinate: \(coordinate.latitude), \(coordinate.longitude)")
            updateLocationAndWeather(coordinate, apiKey: apiKey)
        }
    }


    func updateLocationAndWeather(_ coord: CLLocationCoordinate2D, apiKey: String) {
        self.location = coord
        temperatureFetcher.fetchTemperature(apiKey: apiKey, location: coord)

        let clLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        CLGeocoder().reverseGeocodeLocation(clLocation) { placemarks, error in
            if let placemark = placemarks?.first {
                self.locationName = placemark.locality ?? placemark.name
            } else {
                self.locationName = "Unknown"
            }
        }
    }
}


#Preview {
    LandingView()
}
