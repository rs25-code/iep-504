import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var isEditing = false
    @State private var name = "John Doe"
    @State private var email = "john.doe@email.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var location = "San Francisco, CA"
    @State private var bio = "Dedicated to supporting students with special needs and ensuring they receive the best educational experience possible."
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { appState.navigate(to: .settings) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Text("Profile")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(isEditing ? "Save" : "Edit") {
                    isEditing.toggle()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding()
            .background(Color(.systemBackground))
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 80, height: 80)
                            Text(name.components(separatedBy: " ").compactMap { $0.first }.prefix(2).map(String.init).joined())
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            if isEditing {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Button(action: {}) {
                                            Image(systemName: "camera.fill")
                                                .foregroundColor(.white)
                                                .padding(6)
                                                .background(Color.blue)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .frame(width: 80, height: 80)
                            }
                        }
                        
                        VStack(spacing: 8) {
                            if isEditing {
                                TextField("Name", text: $name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .multilineTextAlignment(.center)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            } else {
                                Text(name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            HStack {
                                Image(systemName: appState.userRole?.icon ?? "person")
                                    .foregroundColor(appState.userRole?.color ?? .primary)
                                Text(appState.userRole?.displayName ?? "User")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(appState.userRole?.color.opacity(0.1) ?? Color.primary.opacity(0.1))
                                    .foregroundColor(appState.userRole?.color ?? .primary)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Contact Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Information")
                            .font(.headline)
                        VStack(spacing: 12) {
                            ProfileField(
                                icon: "envelope",
                                label: "Email",
                                value: $email,
                                isEditing: isEditing
                            )
                            ProfileField(
                                icon: "phone",
                                label: "Phone",
                                value: $phone,
                                isEditing: isEditing
                            )
                            ProfileField(
                                icon: "location",
                                label: "Location",
                                value: $location,
                                isEditing: isEditing
                            )
                        }
                    }
                    
                    // About
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.headline)
                        if isEditing {
                            TextField("Tell us about yourself...", text: $bio, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(4...8)
                        } else {
                            Text(bio)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    // Activity Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Activity Summary")
                            .font(.headline)
                        // LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                            StatCard(title: "IEPs Analyzed", value: "12", icon: "doc.text")
                            StatCard(title: "Questions Asked", value: "48", icon: "message")
                            StatCard(title: "Meetings", value: "6", icon: "calendar")
                            StatCard(title: "Months Active", value: "2", icon: "clock")
                        }
                    }
                }
                .padding()
            }
        }
    }
}
