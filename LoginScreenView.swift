import SwiftUI

struct MessageBubble: View {
    let message: Message
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            HStack(alignment: .top, spacing: 8) {
                if !message.isFromUser {
                    Image(systemName: "robot")
                        .foregroundColor(.blue)
                        .frame(width: 32, height: 32)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(16)
                }
                VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                    Text(message.text)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(message.isFromUser ? Color.blue : Color(.systemGray5))
                        .foregroundColor(message.isFromUser ? .white : .primary)
                        .cornerRadius(16)
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                }
                if message.isFromUser {
                    Image(systemName: "person")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.gray)
                        .cornerRadius(16)
                }
            }
            if !message.isFromUser {
                Spacer()
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
