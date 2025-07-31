import SwiftUI
import Foundation

// MARK: - Data Models
enum UserRole: String, CaseIterable {
    case parent = "parent"
    case teacher = "teacher"
    case counselor = "counselor"
    var displayName: String {
        return rawValue.capitalized
    }
    var icon: String {
        switch self {
        case .parent: return "heart.fill"
        case .teacher: return "graduationcap.fill"
        case .counselor: return "person.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .parent: return .orange
        case .teacher: return .orange
        case .counselor: return .orange
        }
    }
}

struct IEPData {
    let studentName: String
    let fileName: String
    let uploadDate: Date
    let notes: String
    let overallScore: Int
    let summary: String
    let strengths: [String]
    let concerns: [String]
    let recommendations: [String]
    let goals: [IEPGoal]
    let services: [IEPService]
}

struct IEPGoal {
    let area: String
    let goal: String
    let status: GoalStatus
    let progress: Int
    
    enum GoalStatus: String {
        case onTrack = "On Track"
        case needsAttention = "Needs Attention"
        case behind = "Behind"
        
        var color: Color {
            switch self {
            case .onTrack: return .green
            case .needsAttention: return .orange
            case .behind: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .onTrack: return "checkmark.circle.fill"
            case .needsAttention: return "clock.fill"
            case .behind: return "exclamationmark.triangle.fill"
            }
        }
    }
}

struct IEPService {
    let service: String
    let frequency: String
    let provider: String
}

struct Message {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var currentScreen: Screen = .landing
    @Published var userRole: UserRole? = nil
    @Published var isLoggedIn: Bool = false
    @Published var currentIEP: IEPData? = nil
    @Published var demoMode: Bool = false
    
    enum Screen: Hashable {
        case landing
        case roleSelection
        case login
        case dashboard
        case upload
        case analysis
        case qa
        case settings
        case profile
    }
    
    func navigate(to screen: Screen) {
        currentScreen = screen
    }
    
    func login(as role: UserRole) {
        userRole = role
        isLoggedIn = true
        currentScreen = .dashboard
    }
    
    func logout() {
        userRole = nil
        isLoggedIn = false
        currentIEP = nil
        currentScreen = .landing
    }
    
    func loadSampleIEP() {
        currentIEP = IEPData(
            studentName: "Emma Johnson",
            fileName: "sample-iep.pdf",
            uploadDate: Date(),
            notes: "Updated with new goals for this semester",
            overallScore: 85,
            summary: "This IEP shows strong alignment with the student's needs in reading comprehension and social skills development. Key areas of focus include phonemic awareness, reading fluency, and peer interaction skills.",
            strengths: [
                "Clear, measurable goals for reading comprehension",
                "Appropriate accommodations for testing situations",
                "Strong parent-school collaboration documented",
                "Regular progress monitoring schedule established"
            ],
            concerns: [
                "Math goals could be more specific and measurable",
                "Transition planning needs more detail for high school",
                "Limited assistive technology considerations"
            ],
            recommendations: [
                "Consider adding specific math intervention strategies",
                "Include more detailed transition goals for post-secondary",
                "Evaluate need for assistive technology assessment",
                "Schedule more frequent team meetings during transitions"
            ],
            goals: [
                IEPGoal(area: "Reading", goal: "Improve reading comprehension to grade level", status: .onTrack, progress: 75),
                IEPGoal(area: "Math", goal: "Master basic multiplication facts", status: .needsAttention, progress: 45),
                IEPGoal(area: "Social Skills", goal: "Initiate peer interactions appropriately", status: .onTrack, progress: 80)
            ],
            services: [
                IEPService(service: "Speech Therapy", frequency: "2x/week", provider: "School SLP"),
                IEPService(service: "Resource Room", frequency: "Daily", provider: "Special Ed Teacher"),
                IEPService(service: "Counseling", frequency: "1x/week", provider: "School Counselor")
            ]
        )
    }
}

// MARK: - Main App
struct ContentView: View {
    @StateObject private var appState = AppState()
    
    // Computed property to determine if we should show sidebar
    private var shouldShowSidebar: Bool {
        appState.isLoggedIn && 
        appState.currentScreen != .landing && 
        appState.currentScreen != .roleSelection &&
        appState.currentScreen != .login
    }
    
    var body: some View {
        Group {
            if shouldShowSidebar {
                // Show NavigationSplitView with sidebar for logged-in screens
                NavigationSplitView {
                    List {
                        Button("Dashboard") {
                            appState.navigate(to: .dashboard)
                        }
                        .foregroundColor(appState.currentScreen == .dashboard ? .orange : .primary)
                        
                        Button("Upload") {
                            appState.navigate(to: .upload)
                        }
                        .foregroundColor(appState.currentScreen == .upload ? .orange : .primary)
                        
                        Button("Analysis") {
                            appState.navigate(to: .analysis)
                        }
                        .foregroundColor(appState.currentScreen == .analysis ? .orange : .primary)
                        
                        Button("Q&A") {
                            appState.navigate(to: .qa)
                        }
                        .foregroundColor(appState.currentScreen == .qa ? .orange : .primary)
                        
                        Button("Settings") {
                            appState.navigate(to: .settings)
                        }
                        .foregroundColor(appState.currentScreen == .settings ? .orange : .primary)
                        
                        Button("Profile") {
                            appState.navigate(to: .profile)
                        }
                        .foregroundColor(appState.currentScreen == .profile ? .orange : .primary)
                    }
                    .navigationTitle("SpectrumEdge")
                    .accentColor(.orange)
                } detail: {
                    mainContentView()
                }
            } else {
                // Show full-screen view for landing, role selection, and login screens
                mainContentView()
            }
        }
        .environmentObject(appState)
        .accentColor(.orange)
    }
    
    @ViewBuilder
    private func mainContentView() -> some View {
        switch appState.currentScreen {
        case .landing:
            LandingScreen()
        case .roleSelection:
            RoleSelectionScreen()
        case .login:
            LoginScreen()
        case .dashboard:
            DashboardScreen()
        case .upload:
            PlaygroundsUploadScreen()
        case .analysis:
            AnalysisScreen()
        case .qa:
            QAScreen()
        case .settings:
            SettingsScreen()
        case .profile:
            ProfileScreen()
        }
    }
}
