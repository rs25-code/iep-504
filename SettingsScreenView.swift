import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var notificationsEnabled = true
    @State private var emailNotifications = false
    @State private var darkModeEnabled = false
    @State private var analyticsEnabled = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { appState.navigate(to: .dashboard) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Text("Settings")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Profile")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("John Doe")
                                    .fontWeight(.medium)
                                
                                Text(appState.userRole?.displayName ?? "User")
                                    .font(.subheadline)
                                    .foregroundColor(appState.userRole?.color ?? .primary)
                            }
                            
                            Spacer()
                            
                            Button("Edit") {
                                appState.navigate(to: .profile)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        TextField("john.doe@email.com", text: .constant("john.doe@email.com"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true)
                        
                        Button("Change Role") {
                            appState.navigate(to: .roleSelection)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    // Notifications
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Notifications")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            SettingsToggle(
                                title: "Push Notifications",
                                subtitle: "Get notified about IEP updates",
                                isOn: $notificationsEnabled
                            )
                            
                            SettingsToggle(
                                title: "Email Notifications",
                                subtitle: "Receive updates via email",
                                isOn: $emailNotifications
                            )
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Privacy & Security
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Privacy & Security")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            SettingsToggle(
                                title: "Data Analytics",
                                subtitle: "Help improve the app",
                                isOn: $analyticsEnabled
                            )
                            
                            Button("Export My Data") {
                                // Handle export
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            
                            Button("Delete Account") {
                                // Handle delete account
                            }
                            .buttonStyle(DestructiveButtonStyle())
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // App Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("App Preferences")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            SettingsToggle(
                                title: "Dark Mode",
                                subtitle: "Switch to dark theme",
                                isOn: $darkModeEnabled
                            )
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Language")
                                        .fontWeight(.medium)
                                    Text("Currently: English")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button("Change") {
                                    // Handle language change
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Help & Support
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Help & Support")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            SettingsRow(title: "Help Center", action: {})
                            SettingsRow(title: "Contact Support", action: {})
                            SettingsRow(title: "Privacy Policy", action: {})
                            SettingsRow(title: "Terms of Service", action: {})
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Logout
                    Button("Sign Out") {
                        appState.logout()
                    }
                    .buttonStyle(DestructiveButtonStyle())
                }
                .padding()
            }
        }
    }
}
