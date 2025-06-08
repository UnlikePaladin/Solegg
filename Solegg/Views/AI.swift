//
//  AI.swift
//  Solegg
//
//  Created by Alexa Nohemi Lara Carvajal on 08/06/25.
//

import SwiftUI

// Representa un mensaje en el chat
struct Message: Identifiable {
    let id = UUID()
    let content: AttributedString
    let isUser: Bool
}

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @State private var isLoading = false
    @State private var animatingMessageID: UUID?

    var body: some View {
        VStack {
            VStack {
                Image("SoleFeliz").resizable().scaledToFit()
            }
            // Lista de Mensajes
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(messages) { msg in
                        HStack {
                            if msg.isUser { }
                            if !msg.isUser {
                                Text(msg.content)
                                    .padding()
                                    .background(msg.isUser ? .blue : .gray.opacity(0.1))
                                    .foregroundColor(msg.isUser ? .white : .black)
                                    .cornerRadius(12)
                                    
                            }
                            if !msg.isUser { }
                        }
                    }
                }
                .padding()
            }

            // Input de mensaje de usuario
            HStack(spacing: 10) {
                TextField("Escribe un mensaje...", text: $newMessage)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Button(action: sendMessage) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                    }
                }
                .padding(12)
                .background((newMessage.isEmpty || isLoading) ? Color.gray : Color.blue)
                .cornerRadius(10)
                .disabled(newMessage.isEmpty || isLoading)
            }
            .padding()
        }
        .onAppear {
            let intro = try? AttributedString(markdown: "Hola 👋 Soy **Sole**. ¡En que te puedo ayudar!")
            messages.append(Message(content: intro ?? AttributedString("Hola! Soy Kiwi"), isUser: false))
        }
    }

    // Mandar y recibir mensajes del api
    func sendMessage() {
        let newMsg = Message(content: AttributedString(newMessage), isUser: true)
        animatingMessageID = newMsg.id
        messages.append(newMsg)

        let input = newMessage
        newMessage = ""
        isLoading = true

        Task {
            do {
                let reply = try await getGeminiReply(for: input)
                let formatted = try AttributedString(markdown: reply)
                messages.append(Message(content: formatted, isUser: false))
            } catch {
                messages.append(Message(content: AttributedString("Error: \(error.localizedDescription)"), isUser: false))
            }

            isLoading = false
            animatingMessageID = nil // reset animation ID
        }
    }


    // Gemini API call
    func getGeminiReply(for text: String) async throws -> String {
        let apiKey = "AIzaSyDx4YZnvwEVyHQcLxoo3x3MjURSnN00YW0" // Add your Gemini API key
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)")!

        let body: [String: Any] = [
            "system_instruction": [
                "parts": [["text": "You´re Sole, a fried egg that wants to help people by giving them advise on how to deal and avoid excesive heat in their localities. You always have a cheery attitude. You use emojis sometimes."]]
            ],
            "contents": [
                ["parts": [["text": text]]]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let reply = (((json?["candidates"] as? [[String: Any]])?.first)?["content"] as? [String: Any])?["parts"] as? [[String: Any]]
        return reply?.first?["text"] as? String ?? "No reply."
    }
}

// Preview
#Preview {
    ChatView()
}
