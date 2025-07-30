import SwiftUI

struct PlaygroundsQAScreen: View {
    @EnvironmentObject var appState: AppState
    let documentText: String
    let studentName: String
    let llmService: PlaygroundsLLMService
    
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @State private var isTyping = false
    @State private var testText = "Type here to test"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button("Close") { dismiss() }
                Spacer()
                Text("AI Chat - \(studentName)")
                Spacer()
            }
            .padding()
            
            // Debug Text Fields
            VStack(spacing: 16) {
                Text("Debug: Can you type in these fields?")
                    .font(.headline)
                
                TextField("Test Field 1", text: $testText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                TextField("Test Field 2", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Text("Current input: '\(inputText)'")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Messages Area
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(messages, id: \.id) { message in
                        HStack {
                            if message.isFromUser {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            // Test Buttons
            VStack(spacing: 8) {
                Button("Test: Ask about goals") {
                    askQuestion("What are the main educational goals?")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Send Current Input") {
                    if !inputText.isEmpty {
                        askQuestion(inputText)
                    }
                }
                .buttonStyle(.bordered)
                .disabled(inputText.isEmpty)
            }
            
            Spacer()
        }
        .onAppear {
            if messages.isEmpty {
                messages.append(Message(
                    text: "Hello! Try typing in the text fields above. If they work, we can fix the main input. If not, there's a Swift Playgrounds keyboard issue.",
                    isFromUser: false,
                    timestamp: Date()
                ))
            }
        }
    }
    
    private func askQuestion(_ question: String) {
        let userMessage = Message(text: question, isFromUser: true, timestamp: Date())
        messages.append(userMessage)
        inputText = ""
        isTyping = true
        
        Task {
            let response = await llmService.askQuestion(question, about: documentText)
            await MainActor.run {
                let aiMessage = Message(text: response, isFromUser: false, timestamp: Date())
                messages.append(aiMessage)
                isTyping = false
            }
        }
    }
}
