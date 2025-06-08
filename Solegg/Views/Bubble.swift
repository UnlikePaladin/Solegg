//
//  Bubble.swift
//  Solegg
//
//  Created by Alexa Nohemi Lara Carvajal on 07/06/25.
//

import SwiftUI

struct Bubble: View {
    let goal: Goal
    @State var showModal = false

    var body: some View {
        VStack {
            Button(action: {
                showModal.toggle()
            }) {
                VStack {
                    Image(systemName: goal.content.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(goal.state ? Color.green : Color.blue.opacity(0.3))
                        .clipShape(Circle())
                        .foregroundColor(.primary)
                    
                    Text(goal.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
            .sheet(isPresented: $showModal) {
                GoalModalView(modal: goal.content)
            }
        }
    }
}
