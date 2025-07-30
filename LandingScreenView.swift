import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { appState.navigate(to: .roleSelection) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Text("Sign In")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Welcome back!")
                            .font(.title2)
                            .fontWeight(.semibold)
                        if let role = appState.userRole {
                            Text("Signing in as \(role.displayName)")
                                .font(.subheadline)
                                .foregroundColor(role.color)
                        }
                    }
                    .padding(.top, 40)
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            HStack {
                                if showPassword {
                                    TextField("Enter your password", text: $password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                }
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        Button(action: handleLogin) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                }
                                Text(isLoading ? "Signing in..." : "Sign In")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(email.isEmpty || password.isEmpty || isLoading)
                        
                        VStack(spacing: 8) {
                            Button("Forgot password?") {
                                // Handle forgot password
                            }
                            .font(.subheadline)
                            HStack {
                                Text("Don't have an account?")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Button("Sign up") {
                                    // Handle sign up
                                }
                                .font(.subheadline)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func handleLogin() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            appState.login(as: appState.userRole ?? .parent)
        }
    }
}
