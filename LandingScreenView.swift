import SwiftUI

struct LandingScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text("IEP Analyzer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("AI-powered IEP analysis and support for students, parents, and educators")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
            // Features
            VStack(spacing: 16) {
                FeatureCard(
                    icon: "brain.head.profile",
                    title: "AI-Powered Analysis",
                    description: "Get instant insights and summaries from IEP documents",
                    color: .blue
                )
                FeatureCard(
                    icon: "person.2.fill",
                    title: "Collaborative Platform",
                    description: "Connect parents, teachers, and counselors seamlessly",
                    color: .green
                )
                FeatureCard(
                    icon: "shield.fill",
                    title: "Secure & Private",
                    description: "FERPA compliant with end-to-end encryption",
                    color: .purple
                )
            }
            .padding(.horizontal)
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                Button("Get Started") {
                    appState.navigate(to: .roleSelection)
                }
                .buttonStyle(PrimaryButtonStyle())
                Button("Sign In") {
                    appState.navigate(to: .login)
                }
                .buttonStyle(SecondaryButtonStyle())
                Button("🚀 Quick Demo (Skip to Dashboard)") {
                    appState.login(as: .parent)
                    appState.loadSampleIEP()
                }
                .buttonStyle(TertiaryButtonStyle())
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.indigo.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
