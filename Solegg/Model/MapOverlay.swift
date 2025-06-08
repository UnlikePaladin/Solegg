//
//  MapOverlay.swift
//  Solegg
//
//

import Foundation
import MapKit

class MapOverlay: NSObject, MKOverlay{
    let coordinate: CLLocationCoordinate2D
    let boundingMapRect: MKMapRect

    init(worldMap: WorldMap) {
        boundingMapRect = worldMap.overlayBoundingMapRect
        coordinate = worldMap.midCoordinate
    }
}
