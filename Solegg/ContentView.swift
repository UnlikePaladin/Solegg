//
//  ContentView.swift
//  Solegg
//
//

import SwiftUI
import CoreData
import MapKit
struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        TabView {
            DailyGoal(viewModel: Steps())
                .tabItem{
                    Label("DailyGoal", systemImage:"play.fill")
                }
    
            LandingView()
                .tabItem{
                    Label("Home", systemImage:"house.fill")
                }
            MapView(viewModel: viewModel)
                .tabItem{
                    Label("Map View", systemImage: "map.fill")
                }
            ChatView()
                .tabItem{
                    Label("Chat View", systemImage: "bubble.fill")
                }
        }.onAppear() {
            CLLocationManager().requestAlwaysAuthorization()
        }
    }

}



final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.457105, longitude: -80.508361), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

    var binding: Binding<MKCoordinateRegion> {
        Binding {
            self.mapRegion
        } set: { newRegion in
            self.mapRegion = newRegion
        }
    }

    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            print("Show an alert letting them know this is off")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let previousAuthorizationStatus = manager.authorizationStatus
        manager.requestWhenInUseAuthorization()
        if manager.authorizationStatus != previousAuthorizationStatus {
            checkLocationAuthorization()
        }
    }

    private func checkLocationAuthorization() {
        guard let location = locationManager else {
            return
        }

        switch location.authorizationStatus {
        case .notDetermined:
            print("Location authorization is not determined.")
        case .restricted:
            print("Location is restricted.")
        case .denied:
            print("Location permission denied.")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = location.location {
                mapRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            }

        default:
            break
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
