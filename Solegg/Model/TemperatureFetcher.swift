//
//  TemperatureViewer.swift
//  Solegg
//
//

import Foundation
import MapKit

@MainActor
class TemperatureFetcher: ObservableObject {
    @Published var temperature: Double?
    private var userDefaultsKey = "CachedTemperature"

    func fetchTemperature(apiKey: String, location: CLLocationCoordinate2D) {
        if let saved = UserDefaults.standard.object(forKey: userDefaultsKey) as? [String: Any],
            let timestamp = saved["timestamp"] as? TimeInterval,
            let cached = saved["temperature"] as? Double,
            let lat = saved["lat"] as? Double,
            let lon = saved["lon"] as? Double,
            abs(lat - location.latitude) < 0.01,
            abs(lon - location.longitude) < 0.01,
           
            Date().timeIntervalSince1970 - timestamp < 600 {
                self.temperature = cached
            return
        }

        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch weather data:", error ?? "Unknown error")
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let main = json["main"] as? [String: Any],
               let temp = main["temp"] as? Double {
                DispatchQueue.main.async {
                    self.temperature = temp
                    UserDefaults.standard.set([
                        "temperature": temp,
                        "timestamp": Date().timeIntervalSince1970,
                        "lat": location.latitude,
                        "lon": location.longitude
                    ], forKey: self.userDefaultsKey)
                }
            }
        }.resume()
    }
}
