import SwiftUI

struct LandingScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                    .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text("SpectrumEdge")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("AI-powered IEP and 504 plan analysis and support for students, parents, and educators")
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
                    description: "Get instant insights and summaries from IEP and 504 documents",
                    color: .orange
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
                    description: "FERPA and IDEA compliant with end-to-end encryption",
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
                colors: [Color.orange.opacity(0.1), Color.orange.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
