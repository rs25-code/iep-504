import SwiftUI

struct UploadScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var uploadMethod: UploadMethod = .file
    @State private var studentName = ""
    @State private var notes = ""
    @State private var hasFile = false
    @State private var sharedLink = ""
    @State private var isUploading = false
    @State private var uploadSuccess = false
    
    enum UploadMethod {
        case file, link
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { appState.navigate(to: .dashboard) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Text("Upload IEP")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            
            ScrollView {
                VStack(spacing: 20) {
                    // Upload Method Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upload Method")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            Button(action: { uploadMethod = .file }) {
                                HStack {
                                    Image(systemName: "doc.text")
                                    Text("PDF File")
                                }
                            }
                            .buttonStyle(.bordered)
                            .background(uploadMethod == .file ? Color.blue : Color.clear)
                            .foregroundColor(uploadMethod == .file ? .white : .primary)
                            .cornerRadius(8)
                            
                            Button(action: { uploadMethod = .link }) {
                                HStack {
                                    Image(systemName: "link")
                                    Text("Shared Drive")
                                }
                            }
                            .buttonStyle(.bordered)
                            .background(uploadMethod == .link ? Color.blue : Color.clear)
                            .foregroundColor(uploadMethod == .link ? .white : .primary)
                            .cornerRadius(8)
                        }
                    }
                    
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
                                    Button("Demo") {
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
                            
                            TextField("Add any additional context or notes...", text: $notes, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                        }
                    }
                    
                    // File Upload
                    VStack(alignment: .leading, spacing: 12) {
                        Text(uploadMethod == .file ? "Upload PDF" : "Shared Drive Link")
                            .font(.headline)
                        
                        if uploadMethod == .file {
                            VStack(spacing: 16) {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    .foregroundColor(.gray.opacity(0.5))
                                    .frame(height: 120)
                                    .overlay(
                                        VStack(spacing: 12) {
                                            if hasFile {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.green)
                                                
                                                Text("sample-iep.pdf")
                                                    .fontWeight(.medium)
                                                
                                                Text("500 KB")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            } else {
                                                Image(systemName: "square.and.arrow.up")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.gray)
                                                
                                                Text("Upload PDF File")
                                                    .fontWeight(.medium)
                                                
                                                Text("Select a PDF file from your device")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                
                                                Button("Choose File or Use Demo PDF") {
                                                    hasFile = true
                                                }
                                                .buttonStyle(.bordered)
                                                .controlSize(.small)
                                            }
                                        }
                                    )
                            }
                        } else {
                            VStack(spacing: 16) {
                                TextField("https://drive.google.com/file/d/...", text: $sharedLink)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button("Use Demo Shared Link") {
                                    sharedLink = "https://drive.google.com/file/d/demo-iep-document"
                                }
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                                
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.orange)
                                    Text("Ensure the link has proper viewing permissions")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    // Upload Status
                    if uploadSuccess {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Upload Successful!")
                                    .fontWeight(.medium)
                                    .foregroundColor(.green)
                                Text("Redirecting to analysis...")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                if hasFile || !sharedLink.isEmpty {
                    Button("Preview PDF") {
                        // Handle preview
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                Button(action: handleUpload) {
                    HStack {
                        if isUploading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(isUploading ? "Processing..." : "Upload & Analyze")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!canSubmit)
            }
            .padding()
        }
    }
    
    private var canSubmit: Bool {
        !studentName.isEmpty && (hasFile || !sharedLink.isEmpty) && !isUploading
    }
    
    private func handleUpload() {
        isUploading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isUploading = false
            uploadSuccess = true
            appState.loadSampleIEP()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appState.navigate(to: .analysis)
            }
        }
    }
}
