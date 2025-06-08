//
//  Bubble.swift
//  Solegg
//
//

import SwiftUI

struct Bubble: View {
    @Binding var goal: Goal
    @State private var showModal = false

    var body: some View {
        VStack {
            Button(action: {
                showModal.toggle()
            }) {
                VStack {
                    Image(goal.content.imageName)
                        .resizable().aspectRatio(contentMode: .fit)
                        .padding(CGFloat(20))
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
                GoalModalView(
                    modal: goal.content,
                    onDone: {
                        goal.state = true
                        showModal = false
                    }
                )
            }
        }
    }
}
