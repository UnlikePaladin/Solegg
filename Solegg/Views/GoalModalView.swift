//
//  GoalModalView.swift
//  Solegg
//
//  Created by Alexa Nohemi Lara Carvajal on 07/06/25.
//
import SwiftUI

struct GoalModalView: View {
    let modal: Modal

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: modal.imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .padding()

            Text(modal.title)
                .font(.title)
                .bold()

            Text(modal.desc)
                .font(.body)
                .padding()

            Text("🔥 \(modal.exp) EXP")
                .font(.headline)
                .foregroundColor(.orange)

            Spacer()
        }
        .padding()
    }
}
