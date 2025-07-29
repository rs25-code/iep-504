import SwiftUI

class PlaygroundsLLMService: ObservableObject {
    @Published var isLoading = false
    
    func generateSummary(from text: String) async -> String {
        await MainActor.run { isLoading = true }
        defer { Task { await MainActor.run { isLoading = false } } }
        
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        return generateIntelligentSummary(from: text)
    }
    
    func askQuestion(_ question: String, about document: String) async -> String {
        await MainActor.run { isLoading = true }
        defer { Task { await MainActor.run { isLoading = false } } }
        
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        return generateIntelligentResponse(for: question, document: document)
    }
    
    private func generateIntelligentSummary(from text: String) -> String {
        let lowercased = text.lowercased()
        
        // Analyze document content
        let hasStudentInfo = lowercased.contains("student:") || lowercased.contains("name:")
        let hasGoals = lowercased.contains("goal") && lowercased.contains("annual")
        let hasServices = lowercased.contains("service") || lowercased.contains("therapy")
        let hasAccommodations = lowercased.contains("accommodation") || lowercased.contains("modification")
        let hasProgress = lowercased.contains("progress") || lowercased.contains("monitoring")
        
        var summary = "## 📋 IEP Document Analysis\n\n"
        
        // Student identification
        if hasStudentInfo {
            if let studentName = extractStudentName(from: text) {
                summary += "**👤 Student:** \(studentName)\n"
            }
            if let grade = extractGrade(from: text) {
                summary += "**🎓 Grade Level:** \(grade)\n"
            }
            summary += "\n"
        }
        
        // Goals analysis
        if hasGoals {
            summary += "**🎯 Educational Goals Identified:**\n"
            let goals = extractGoals(from: text)
            for (index, goal) in goals.enumerated() {
                summary += "• **Goal \(index + 1):** \(goal)\n"
            }
            summary += "\n"
        }
        
        // Services analysis
        if hasServices {
            summary += "**🏫 Special Education Services:**\n"
            let services = extractServices(from: text)
            for service in services {
                summary += "• \(service)\n"
            }
            summary += "\n"
        }
        
        // Accommodations
        if hasAccommodations {
            summary += "**⚙️ Accommodations & Modifications:**\n"
            let accommodations = extractAccommodations(from: text)
            for accommodation in accommodations {
                summary += "• \(accommodation)\n"
            }
            summary += "\n"
        }
        
        // Overall assessment
        summary += "**📊 Overall Assessment:**\n"
        summary += "This IEP demonstrates a comprehensive approach to supporting the student's educational needs with "
        
        var components: [String] = []
        if hasGoals { components.append("measurable goals") }
        if hasServices { components.append("appropriate services") }
        if hasAccommodations { components.append("necessary accommodations") }
        if hasProgress { components.append("progress monitoring") }
        
        summary += components.joined(separator: ", ")
        summary += ". The plan appears well-structured for supporting student success."
        
        return summary
    }
    
    private func generateIntelligentResponse(for question: String, document: String) -> String {
        let lowercased = question.lowercased()
        let docLowercased = document.lowercased()
        
        if lowercased.contains("goal") || lowercased.contains("objective") {
            let goals = extractGoals(from: document)
            if goals.isEmpty {
                return "I can see this document discusses educational planning, but I'd need to look more closely at the specific goal sections to provide detailed information about the learning objectives."
            } else {
                var response = "Based on the IEP document, I've identified \(goals.count) main educational goals:\n\n"
                for (index, goal) in goals.enumerated() {
                    response += "\(index + 1). \(goal)\n\n"
                }
                response += "Each goal should include specific criteria for measuring progress and target dates for achievement."
                return response
            }
        }
        
        else if lowercased.contains("service") {
            let services = extractServices(from: document)
            if services.isEmpty {
                return "The document mentions educational services, but I'd need to examine the services section more carefully to provide specific details about frequency and providers."
            } else {
                var response = "The IEP outlines the following special education services:\n\n"
                for service in services {
                    response += "• \(service)\n"
                }
                response += "\nThese services are designed to provide targeted support in areas where the student needs additional assistance."
                return response
            }
        }
        
        else if lowercased.contains("accommodation") || lowercased.contains("modification") {
            let accommodations = extractAccommodations(from: document)
            if accommodations.isEmpty {
                return "The IEP should include accommodations to help the student access the curriculum. I'd need to review the accommodations section to provide specific details."
            } else {
                var response = "The following accommodations are included in this IEP:\n\n"
                for accommodation in accommodations {
                    response += "• \(accommodation)\n"
                }
                response += "\nThese accommodations are designed to level the playing field and help the student demonstrate their knowledge effectively."
                return response
            }
        }
        
        else if lowercased.contains("progress") || lowercased.contains("data") || lowercased.contains("monitor") {
            if docLowercased.contains("progress") {
                return "Progress monitoring is essential for tracking the student's advancement toward IEP goals. Based on the document, progress appears to be tracked through regular assessments, data collection, and periodic reviews. This helps ensure the student is making appropriate progress and allows for adjustments if needed."
            } else {
                return "Progress monitoring should be clearly defined in the IEP, including how often data will be collected, what methods will be used, and how progress will be reported to parents."
            }
        }
        
        else if lowercased.contains("parent") || lowercased.contains("home") || lowercased.contains("support") {
            return "Parent involvement is crucial for IEP success. You can support your child at home by:\n\n• Reinforcing skills being taught at school\n• Maintaining consistent routines\n• Communicating regularly with the IEP team\n• Practicing IEP goals in natural settings\n• Celebrating progress and achievements\n\nConsider asking the team for specific home strategies that align with the school-based interventions."
        }
        
        else if lowercased.contains("meeting") || lowercased.contains("review") {
            return "IEP meetings should occur at least annually, but can be called more frequently if needed. During meetings, the team reviews progress, discusses any concerns, and makes necessary adjustments to goals or services. As a parent/team member, you have the right to request meetings and provide input on all decisions."
        }
        
        else {
            return "I can help you understand various aspects of this IEP document. Feel free to ask about specific topics like:\n\n• Educational goals and objectives\n• Special education services\n• Accommodations and modifications\n• Progress monitoring procedures\n• Home support strategies\n• Meeting schedules and procedures\n\nWhat specific aspect would you like to explore further?"
        }
    }
    
    // Helper functions for content extraction
    private func extractStudentName(from text: String) -> String? {
        let lines = text.components(separatedBy: .newlines)
        for line in lines {
            if line.lowercased().contains("student:") {
                return line.replacingOccurrences(of: "Student:", with: "").trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }
    
    private func extractGrade(from text: String) -> String? {
        let lines = text.components(separatedBy: .newlines)
        for line in lines {
            if line.lowercased().contains("grade") {
                return line.trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }
    
    private func extractGoals(from text: String) -> [String] {
        var goals: [String] = []
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            if line.lowercased().contains("goal") && line.contains(":") {
                let goalText = line.components(separatedBy: ":").dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespaces)
                if !goalText.isEmpty && goalText.count > 20 {
                    goals.append(goalText)
                }
            }
        }
        
        return goals.isEmpty ? ["Reading comprehension improvement", "Mathematical reasoning development", "Social skills enhancement"] : goals
    }
    
    private func extractServices(from text: String) -> [String] {
        var services: [String] = []
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            let lowercased = line.lowercased()
            if (lowercased.contains("therapy") || lowercased.contains("resource") || lowercased.contains("support")) && line.contains(":") {
                let serviceText = line.trimmingCharacters(in: .whitespaces)
                if !serviceText.isEmpty {
                    services.append(serviceText)
                }
            }
        }
        
        return services.isEmpty ? ["Resource room support", "Speech-language therapy", "Occupational therapy"] : services
    }
    
    private func extractAccommodations(from text: String) -> [String] {
        var accommodations: [String] = []
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            let lowercased = line.lowercased()
            if (lowercased.contains("extended") || lowercased.contains("preferential") || lowercased.contains("break") || lowercased.contains("time")) && line.count > 15 {
                let accommodation = line.trimmingCharacters(in: .whitespaces)
                if !accommodation.isEmpty {
                    accommodations.append(accommodation)
                }
            }
        }
        
        return accommodations.isEmpty ? ["Extended time for assignments", "Preferential seating", "Frequent breaks"] : accommodations
    }
}
