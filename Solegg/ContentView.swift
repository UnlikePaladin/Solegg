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
        TabView {
            LandingView()
                .tabItem{
                    Label("Home", systemImage:"house.fill")
                }
        }.onAppear() {
            
        }
    }

}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
