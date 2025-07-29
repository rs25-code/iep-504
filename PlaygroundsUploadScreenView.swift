import SwiftUI

struct PlaygroundsUploadScreen: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var pdfManager = PlaygroundsPDFManager()
    @StateObject private var llmService = PlaygroundsLLMService()
    @State private var studentName = ""
    @State private var notes = ""
    @State private var hasSelectedFile = false
    @State private var documentSummary = ""
    @State private var showingQA = false
    @State private var processingStage: ProcessingStage = .none
    
    enum ProcessingStage {
        case none, extracting, analyzing, complete
        
        var description: String {
            switch self {
            case .none: return ""
            case .extracting: return "Processing document..."
            case .analyzing: return "Analyzing with AI..."
            case .complete: return "Analysis complete!"
            }
        }
        
        var icon: String {
            switch self {
            case .none: return ""
            case .extracting: return "doc.text.magnifyingglass"
            case .analyzing: return "brain"
            case .complete: return "checkmark.circle.fill"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { appState.navigate(to: .dashboard) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Text("Upload & Analyze IEP")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            
            ScrollView {
                VStack(spacing: 20) {
                    // Playgrounds Notice
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            Text("Swift Playgrounds Demo Mode")
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        Text("This demo simulates PDF upload and analysis. In a full iOS app, you would select actual PDF files.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Student Information
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Student Information")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Student Name *")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            HStack {
                                TextField("Enter student's name", text: $studentName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                if studentName.isEmpty {
                                    Button("Use Demo") {
                                        studentName = "Emma Johnson"
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(6)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Add any additional context...", text: $notes, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                        }
                    }
                    
                    // Simulated File Upload Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("PDF Document")
                            .font(.headline)
                        
                        Button(action: simulateFileSelection) {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(hasSelectedFile ? .green : .blue.opacity(0.5))
                                .frame(height: 120)
                                .overlay(
                                    VStack(spacing: 12) {
                                        if hasSelectedFile {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundColor(.green)
                                            
                                            Text(pdfManager.fileName.isEmpty ? "sample-iep.pdf" : pdfManager.fileName)
                                                .fontWeight(.medium)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.center)
                                        } else {
                                            Image(systemName: "doc.badge.plus")
                                                .font(.largeTitle)
                                                .foregroundColor(.blue)
                                            
                                            Text("Tap to Simulate PDF Selection")
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                            
                                            Text("(In full app: Select from Files)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                )
                        }
                        .foregroundColor(.primary)
                    }
                    
                    // Processing Status
                    if processingStage != .none {
                        VStack(spacing: 12) {
                            HStack {
                                if processingStage != .complete {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: processingStage.icon)
                                        .foregroundColor(.green)
                                }
                                Text(processingStage.description)
                                    .font(.subheadline)
                                    .foregroundColor(processingStage == .complete ? .green : .blue)
                                Spacer()
                            }
                            
                            if !pdfManager.extractedText.isEmpty {
                                Text("Processed \(pdfManager.extractedText.count) characters from document")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(processingStage == .complete ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Document Summary
                    if !documentSummary.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.blue)
                                Text("AI Analysis Summary")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            
                            Text(documentSummary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                if hasSelectedFile && !pdfManager.extractedText.isEmpty && !documentSummary.isEmpty {
                    Button("Ask Questions About This IEP") {
                        showingQA = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                
                Button(action: processDocument) {
                    HStack {
                        if processingStage != .none && processingStage != .complete {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(getButtonTitle())
                    }
                }
                //.buttonStyle(hasSelectedFile ? PrimaryButtonStyle() : SecondaryButtonStyle())
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!canProcess || (processingStage != .none && processingStage != .complete))
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showingQA) {
            PlaygroundsQAScreen(
                documentText: pdfManager.extractedText,
                studentName: studentName,
                llmService: llmService
            )
            .environmentObject(appState)
        }
        .onChange(of: pdfManager.extractedText) { oldValue, newValue in
            if !newValue.isEmpty && processingStage == .extracting {
                Task {
                    processingStage = .analyzing
                    let summary = await llmService.generateSummary(from: newValue)
                    await MainActor.run {
                        documentSummary = summary
                        processingStage = .complete
                    }
                }
            }
        }
    }
    
    private var canProcess: Bool {
        hasSelectedFile && !studentName.isEmpty
    }
    
    private func getButtonTitle() -> String {
        if !hasSelectedFile {
            return "Select Document First"
        } else if pdfManager.extractedText.isEmpty {
            return "Analyze Document"
        } else if documentSummary.isEmpty {
            return "Generating Summary..."
        } else {
            return "Analysis Complete ✓"
        }
    }
    
    private func simulateFileSelection() {
        hasSelectedFile = true
        pdfManager.fileName = "sample-iep-\(studentName.isEmpty ? "document" : studentName.replacingOccurrences(of: " ", with: "-")).pdf"
    }
    
    private func processDocument() {
        guard hasSelectedFile else { return }
        
        processingStage = .extracting
        pdfManager.processSelectedFile(fileName: pdfManager.fileName)
    }
}
