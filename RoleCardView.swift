import SwiftUI

struct RoleCard: View {
    let role: UserRole
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: role.icon)
                    .font(.system(size: 32))
                    .foregroundColor(role.color)
                    .frame(width: 64, height: 64)
                    .background(role.color.opacity(0.1))
                    .cornerRadius(32)
                VStack(spacing: 8) {
                    Text(role.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(roleDescription(for: role))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
        .foregroundColor(.primary)
    }
    
    private func roleDescription(for role: UserRole) -> String {
        switch role {
        case .parent:
            return "Access your child's IEP analysis, track progress, and communicate with educators"
        case .teacher:
            return "Analyze student IEPs, create implementation plans, and collaborate with teams"
        case .counselor:
            return "Provide guidance, coordinate services, and support student success"
        }
    }
}
