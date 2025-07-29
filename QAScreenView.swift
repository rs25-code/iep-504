import SwiftUI

struct QAScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var messages: [Message] = [
        Message(
            text: "Hello! I'm here to help you understand and work with the IEP. You can ask me questions about goals, accommodations, services, or any specific concerns you have.",
            isFromUser: false,
            timestamp: Date().addingTimeInterval(-60)
        )
    ]
    
    @State private var inputText = ""
    @State private var isTyping = false
    
    let suggestedQuestions = [
        "What are the main goals in this IEP?",
        "Are the accommodations appropriate?",
        "How can I support these goals at home?",
        "What services are being provided?",
        "When is the next review meeting?",
        "What does this assessment data mean?"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { appState.navigate(to: .analysis) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                HStack {
                    Image(systemName: "robot")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("AI Assistant")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Ask about \(appState.currentIEP?.studentName ?? "the IEP")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Messages
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(messages, id: \.id) { message in
                        MessageBubble(message: message)
                    }
                    if isTyping {
                        TypingIndicator()
                    }
                }
                .padding()
            }
            // Suggested Questions (only show if few messages)
            if messages.count <= 1 {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Suggested Questions:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(suggestedQuestions.prefix(3), id: \.self) { question in
                                Button(question) {
                                    inputText = question
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            // Input Bar
            HStack {
                Button(action: {}) {
                    Image(systemName: "paperclip")
                        .foregroundColor(.secondary)
                }
                HStack {
                    TextField("Ask a question about the IEP...", text: $inputText)
                        .textFieldStyle(PlainTextFieldStyle())
                    HStack(spacing: 8) {
                        Button(action: {}) {
                            Image(systemName: "mic")
                                .foregroundColor(.secondary)
                        }
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(inputText.isEmpty ? .secondary : .blue)
                        }
                        .disabled(inputText.isEmpty || isTyping)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(20)
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = Message(text: inputText, isFromUser: true, timestamp: Date())
        messages.append(userMessage)
        let question = inputText
        inputText = ""
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let aiResponse = getAIResponse(for: question)
            let aiMessage = Message(text: aiResponse, isFromUser: false, timestamp: Date())
            messages.append(aiMessage)
            isTyping = false
        }
    }
    
    private func getAIResponse(for question: String) -> String {
        let lowercased = question.lowercased()
        if lowercased.contains("goal") {
            return "Based on the IEP analysis, the main goals focus on reading comprehension (75% progress), math skills (45% progress), and social skills development (80% progress). The reading goal aims to improve comprehension to grade level, while the math goal focuses on mastering basic multiplication facts."
        } else if lowercased.contains("accommodation") {
            return "The IEP includes several accommodations: extended time for tests, preferential seating, and breaks during long activities. These accommodations are appropriate for supporting the student's learning needs and helping them access the curriculum effectively."
        } else if lowercased.contains("home") || lowercased.contains("support") {
            return "To support these goals at home, you can: 1) Practice reading together daily for 15-20 minutes, 2) Use visual aids and manipulatives for math practice, 3) Encourage social interactions through structured playdates, and 4) Maintain consistent routines that support the school strategies."
        } else {
            return "That's a great question! Based on the IEP document, I can help you understand the specific details. Could you be more specific about what aspect you'd like me to explain further?"
        }
    }
}
