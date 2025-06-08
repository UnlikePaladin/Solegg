//
//  SoleggApp.swift
//  Solegg
//
//

import SwiftUI

@main
struct SoleggApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavBar()
        }
    }
}

