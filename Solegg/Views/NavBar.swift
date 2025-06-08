//
//  NavBar.swift
//  Solegg
//
//  Created by Alexa Nohemi Lara Carvajal on 08/06/25.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            LandingView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            MapView(viewModel: ContentViewModel())
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            DailyGoal(viewModel: Steps())
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle")
                }
        }
    }
}
