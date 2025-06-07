//
//  ContentView.swift
//  Solegg
//
//  Created by Ernesto Garza Berrueto on 07/06/25.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
