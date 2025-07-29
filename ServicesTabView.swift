import SwiftUI

struct ServicesTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(appState.currentIEP?.services ?? [], id: \.service) { service in
                HStack {
                    VStack {
                        Image(systemName: "person.2.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(service.service)
                            .fontWeight(.semibold)
                        
                        Text(service.provider)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(service.frequency)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}
