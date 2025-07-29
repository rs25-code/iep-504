import SwiftUI

struct ProfileField: View {
    let icon: String
    let label: String
    @Binding var value: String
    let isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(label)
                    .fontWeight(.medium)
            }
            if isEditing {
                TextField(label, text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(value)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }
}
