import SwiftUI

struct SummaryTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 16) {
            // AI Summary
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "book")
                        .foregroundColor(.blue)
                    Text("AI Summary")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Text(appState.currentIEP?.summary ?? "No summary available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Strengths
            VStack(alignment: .leading, spacing: 12) {
                Text("Strengths Identified")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(appState.currentIEP?.strengths ?? [], id: \.self) { strength in
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            
                            Text(strength)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)
            
            // Concerns
            VStack(alignment: .leading, spacing: 12) {
                Text("Areas of Concern")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(appState.currentIEP?.concerns ?? [], id: \.self) { concern in
                        HStack(alignment: .top) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            
                            Text(concern)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
    }
}
