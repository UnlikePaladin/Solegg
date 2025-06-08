//
//  WorldMap.swift
//  Solegg
//
//

// actual source for all this map stuff
// https://stackoverflow.com/questions/71417144/adding-overlay-to-mkmapview-using-openweathermap-swift

import Foundation
import MapKit

class WorldMap {
    var boundary: [CLLocationCoordinate2D] = []
    
    var midCoordinate = CLLocationCoordinate2D()
    var overlayTopLeftCoordinate = CLLocationCoordinate2D()
    var overlayTopRightCoordinate = CLLocationCoordinate2D()
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
    var overlayBottomRightCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: overlayBottomLeftCoordinate.latitude,
            longitude: overlayTopRightCoordinate.longitude)
    }
    
    var overlayBoundingMapRect: MKMapRect {
        let topLeft = MKMapPoint(overlayTopLeftCoordinate)
        let topRight = MKMapPoint(overlayTopRightCoordinate)
        let bottomLeft = MKMapPoint(overlayBottomLeftCoordinate)
        
        return MKMapRect(
            x: topLeft.x,
            y: topLeft.y,
            width: fabs(topLeft.x - topRight.x),
            height: fabs(topLeft.y - bottomLeft.y))
    }
    
    init(filename: String){
        guard
            let properties = WorldMap.plist(filename) as? [String: Any]
        else { return }
        
        midCoordinate = WorldMap.parseCoord(dict: properties, fieldName: "midCoord")
        overlayTopLeftCoordinate = WorldMap.parseCoord(
            dict: properties,
            fieldName: "overlayTopLeftCoord")
        overlayTopRightCoordinate = WorldMap.parseCoord(
            dict: properties,
            fieldName: "overlayTopRightCoord")
        overlayBottomLeftCoordinate = WorldMap.parseCoord(
            dict: properties,
            fieldName: "overlayBottomLeftCoord")
    }
    
    static func plist(_ plist: String) -> Any? {
        guard let filePath = Bundle.main.path(forResource: plist, ofType: "plist"),
              let data = FileManager.default.contents(atPath: filePath) else { return nil }
        
        do {
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        } catch {
            return nil
        }
    }
    
    static func parseCoord(dict: [String: Any], fieldName: String) -> CLLocationCoordinate2D {
        if let coord = dict[fieldName] as? String {
            let point = NSCoder.cgPoint(for: coord)
            return CLLocationCoordinate2D(
                latitude: CLLocationDegrees(point.x),
                longitude: CLLocationDegrees(point.y))
        }
        return CLLocationCoordinate2D()
    }
}
