import SwiftUI

struct DemoNavigator: View {
    @EnvironmentObject var appState: AppState
    @State private var isExpanded = false
    
    let screens: [(AppState.Screen, String)] = [
        (.landing, "Landing"),
        (.roleSelection, "Role Selection"),
        (.login, "Login"),
        (.dashboard, "Dashboard"),
        (.upload, "Upload"),
        (.analysis, "Analysis"),
        (.qa, "Q&A Chat"),
        (.settings, "Settings"),
        (.profile, "Profile")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            if isExpanded {
                // Expanded Navigator
                VStack(spacing: 0) {
                    HStack {
                        Text("Demo Navigation")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: { isExpanded = false }) {
                            Image(systemName: "xmark")
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    ScrollView {
                        VStack(spacing: 1) {
                            ForEach(Array(screens.enumerated()), id: \.offset) { index, screen in
                                Button(action: {
                                    appState.navigate(to: screen.0)
                                    isExpanded = false
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(appState.currentScreen == screen.0 ? Color.blue : Color.gray)
                                            .frame(width: 12, height: 12)
                                        Text(screen.1)
                                            .fontWeight(appState.currentScreen == screen.0 ? .semibold : .regular)
                                        Spacer()
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(8)
                                        if appState.currentScreen == screen.0 {
                                            Text("Current")
                                                .font(.caption)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding()
                                    .background(appState.currentScreen == screen.0 ? Color(.systemGray6) : Color.clear)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                    
                    Button("Exit Demo Mode") {
                        appState.demoMode = false
                    }
                    .buttonStyle(DestructiveButtonStyle())
                    .padding()
                }
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding()
            } else {
                // Compact Navigator
                HStack {
                    Button(action: goToPrevious) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!canGoPrevious)
                    Button(action: { isExpanded = true }) {
                        HStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                            Text(currentScreenName)
                                .fontWeight(.medium)
                            Text("\(currentScreenIndex + 1)/\(screens.count)")
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(.systemGray5))
                                .cornerRadius(6)
                        }
                    }
                    Button(action: goToNext) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!canGoNext)
                    Divider()
                        .frame(height: 20)
                    Button(action: { appState.demoMode = false }) {
                        Image(systemName: "xmark")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
            }
        }
    }
    
    
    private var currentScreenIndex: Int {
        screens.firstIndex { $0.0 == appState.currentScreen } ?? 0
    }
    
    private var currentScreenName: String {
        screens.first { $0.0 == appState.currentScreen }?.1 ?? "Unknown"
    }
    
    private var canGoPrevious: Bool {
        currentScreenIndex > 0
    }
    
    private var canGoNext: Bool {
        currentScreenIndex < screens.count - 1
    }
    
    private func goToPrevious() {
        guard canGoPrevious else { return }
        let previousScreen = screens[currentScreenIndex - 1]
        appState.navigate(to: previousScreen.0)
    }
    
    private func goToNext() {
        guard canGoNext else { return }
        let nextScreen = screens[currentScreenIndex + 1]
        appState.navigate(to: nextScreen.0)
    }
}
