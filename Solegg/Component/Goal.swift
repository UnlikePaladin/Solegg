//
//  Goal.swift
//  Solegg
//
//

import Foundation
import SwiftUI

struct Modal: Identifiable{
    let id = UUID()
    var imageName: String
    var title: String
    var desc: String
    var exp: Int
    var image: Image {
        Image(imageName)
    }
}


struct Goal: Identifiable{
    let id = UUID()
    var state: Bool
    var name: String
    var content: Modal
}
