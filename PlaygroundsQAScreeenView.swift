import SwiftUI

struct PlaygroundsQAScreen: View {
    @EnvironmentObject var appState: AppState
    let documentText: String
    let studentName: String
    let llmService: PlaygroundsLLMService
    
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @State private var isTyping = false
    @Environment(\.dismiss) private var dismiss
    
    let suggestedQuestions = [
        "What are the main educational goals?",
        "What services are being provided?",
        "What accommodations are included?",
        "How is progress being measured?",
        "How can I support these goals at home?",
        "What should I expect in the next review?"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                
                HStack {
                    Image(systemName: "robot.2.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("AI Assistant")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Questions about \(studentName)'s IEP")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages, id: \.id) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        if isTyping {
                            TypingIndicator()
                                .id("typing")
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    withAnimation {
                        if let lastMessage = messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isTyping) { _, newValue in
                    if newValue {
                        withAnimation {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Suggested Questions (only show if few messages)
            if messages.count <= 1 {
                VStack(alignment: .leading, spacing: 12) {
                    Text("💡 Try asking:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(suggestedQuestions.prefix(3), id: \.self) { question in
                                Button(question) {
                                    inputText = question
                                    sendMessage()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .cornerRadius(20)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            
            // Input Bar
            HStack(spacing: 12) {
                HStack {
                    TextField("Ask about the IEP...", text: $inputText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            sendMessage()
                        }
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(inputText.isEmpty ? .secondary : .blue)
                    }
                    .disabled(inputText.isEmpty || isTyping)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(20)
            }
            .padding()
        }
        .onAppear {
            if messages.isEmpty {
                let welcomeMessage = Message(
                    text: "Hello! I've analyzed \(studentName)'s IEP document and I'm ready to answer your questions. I can help explain goals, services, accommodations, or any other aspects of the educational plan. What would you like to know?",
                    isFromUser: false,
                    timestamp: Date()
                )
                messages.append(welcomeMessage)
            }
        }
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = Message(text: inputText, isFromUser: true, timestamp: Date())
        messages.append(userMessage)
        let question = inputText
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
