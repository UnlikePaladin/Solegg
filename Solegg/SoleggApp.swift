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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
