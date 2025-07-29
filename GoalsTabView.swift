import SwiftUI

struct GoalsTabView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack(spacing: 16) {
            ForEach(appState.currentIEP?.goals ?? [], id: \.area) { goal in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        HStack {
                            Image(systemName: "target")
                                .foregroundColor(.blue)
                            Text(goal.area)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: goal.status.icon)
                                .foregroundColor(goal.status.color)
                            Text(goal.status.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(goal.status.color.opacity(0.1))
                                .foregroundColor(goal.status.color)
                                .cornerRadius(8)
                        }
                    }
                    Text(goal.goal)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Progress")
                                .font(.caption)
                            Spacer()
                            Text("\(goal.progress)%")
                                .font(.caption)
                        }
                        ProgressView(value: Double(goal.progress), total: 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}

