//
//  MapViewComponent.swift
//  Solegg
//
//

import Foundation
import SwiftUI
import MapKit

struct MapViewComponent: UIViewRepresentable {
    let viewModel: ContentViewModel
    var locationManager = CLLocationManager()

    func makeCoordinator() -> Coordinator {
        return Coordinator(locationManager:locationManager)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .mutedStandard
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        context.coordinator.mapView = mapView

        context.coordinator.requestUserLocation()
        let apiKey = Bundle.main.infoDictionary?["OpenWeatherApiKey"] as? String ?? "dummy"

        addOpenWeatherMapOverlay(to: mapView, apiKey: apiKey)
        
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
            mapView.setRegion(region, animated: true)

            addTemperatureAnnotation(to: mapView, at: userLocation, apiKey: apiKey)
        }
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func addOpenWeatherMapOverlay(to mapView: MKMapView, apiKey : String) {
        let template = "https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=\(apiKey)"
        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveLabels)
    }
    
    
    
    func addTemperatureAnnotation(to mapView: MKMapView, at coordinate: CLLocationCoordinate2D, apiKey : String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch weather data")
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let main = json["main"] as? [String: Any],
               let temp = main["temp"] as? Double {

                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "🌡️ \(Int(temp))°C"

                DispatchQueue.main.async {
                    mapView.addAnnotation(annotation)
                }
            }
        }.resume()
    }

    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        weak var mapView: MKMapView?
        var locationManager : CLLocationManager
        
        init(locationManager:CLLocationManager) {
            self.locationManager = locationManager
        }
        
        func requestUserLocation() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first,
                  let mapView = mapView else { return }

            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
            mapView.setRegion(region, animated: true)

            // Solo centramos una vez
            locationManager.stopUpdatingLocation()
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Don't override user location annotation
            if annotation is MKUserLocation {
                return nil
            }

            let identifier = "TemperatureAnnotation"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                // Extract temperature from annotation title
                let temperature = extractTemperature(from: annotation.title ?? "") ?? 0
                
                // Customize appearance: larger, rounded label-style image
                let label = UILabel()
                label.text = annotation.title ?? ""
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textColor = .white
                label.backgroundColor = UIColor.systemBlue
                label.textAlignment = .center
                label.layer.cornerRadius = 10
                label.layer.masksToBounds = true
                label.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
                label.backgroundColor = backgroundColor(for: temperature)

                // Convert UILabel to image
                UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
                label.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                annotationView?.image = image
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }

    }
    
    static func extractTemperature(from title: String?) -> Int? {
        guard let title = title else { return nil }
        let pattern = "\\d+"
        if let match = title.range(of: pattern, options: .regularExpression) {
            return Int(title[match])
        }
        return nil
    }

    static func backgroundColor(for temperature: Int) -> UIColor {
        switch temperature {
        case ..<0:
            return UIColor.systemTeal
        case 0..<15:
            return UIColor.systemBlue
        case 15..<30:
            return UIColor.systemGreen
        case 30..<38:
            return UIColor.systemOrange
        default:
            return UIColor.systemRed
        }
    }
}
