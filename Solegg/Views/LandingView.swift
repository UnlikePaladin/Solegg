//
//  LandingView.swift
//  Solegg
//
//  Created by Ernesto Garza Berrueto on 07/06/25.
//

import SwiftUI

struct LandingView: View {
    @State private var searchText: String = ""

    var body: some View {
        
        NavigationStack {
            
            Image("EmojiSmile").resizable().aspectRatio(contentMode: .fit)
                .padding(CGFloat(20))
        }.padding()
            .searchable(text: $searchText, placement: SearchFieldPlacement.toolbar)
    }
}

#Preview {
    LandingView()
}
