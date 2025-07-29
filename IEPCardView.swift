import SwiftUI

struct IEPCard: View {
    let studentName: String
    let lastUpdated: String
    let status: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person")
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(studentName)
                        .fontWeight(.medium)
                    Text("Updated \(lastUpdated)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(status == "Active" ? Color.blue.opacity(0.1) : Color.orange.opacity(0.1))
                    .foregroundColor(status == "Active" ? .blue : .orange)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .foregroundColor(.primary)
    }
}
