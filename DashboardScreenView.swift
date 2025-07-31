import SwiftUI

struct DashboardScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Dashboard")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Welcome back, \(appState.userRole?.displayName ?? "User")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack {
                    Button(action: { appState.navigate(to: .profile) }) {
                        Image(systemName: "bell")
                    }
                    Button(action: { appState.navigate(to: .settings) }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Cards
                    //LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                        StatCard(title: "Active IEPs", value: "12", icon: "doc.text")
                        StatCard(title: "Active 504s", value: "7", icon: "doc.text")
                        StatCard(title: "Meetings", value: "4", icon: "calendar")
                        StatCard(title: "Updates", value: "8", icon: "chart.line.uptrend.xyaxis")
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.headline)
                            .fontWeight(.semibold)
                        VStack(spacing: 12) {
                            Button(action: { appState.navigate(to: .upload) }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Upload New Student Document")
                                    Spacer()
                                }
                            }
                            .buttonStyle(ActionButtonStyle())
                        }
                    }
                    
                    // Recent IEPs
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Documents")
                            .font(.headline)
                            .fontWeight(.semibold)
                        VStack(spacing: 12) {
                            IEPCard(
                                studentName: "Emma Johnson",
                                lastUpdated: "2 days ago",
                                status: "Active"
                            ) {
                                appState.loadSampleIEP()
                                appState.navigate(to: .analysis)
                            }
                            IEPCard(
                                studentName: "Alex Chen",
                                lastUpdated: "1 week ago",
                                status: "Needs Review"
                            ) {
                                // Handle tap
                            }
                        }
                    }
                }
                .frame(maxWidth: 800)
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
}
