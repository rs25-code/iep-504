import SwiftUI
import AVKit

struct LandingScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showAppName = false
    @State private var showRoles = false
    @State private var player: AVPlayer?
    @State private var videoLoaded = false
    @State private var shouldKeepPlaying = true
    
    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Name - Dark blocky font with optimized animation
                VStack(spacing: 8) {
                    Text("SpectrumEdge")
                        .font(.system(size: 48, weight: .black, design: .default))
                        .foregroundColor(.white) // Changed to white for black background
                        .opacity(showAppName ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.5).delay(0.5), value: showAppName) // Slower, delayed animation
                    
                    Text("AI-Powered IEP Analysis")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8)) // Changed to white for black background
                        .opacity(showAppName ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.5).delay(1.0), value: showAppName) // More delayed
                }
                
                // Centered Video Player
                VStack {
                    if videoLoaded, let player = player {
                        VideoPlayer(player: player)
                            .frame(width: 600, height: 400)
                            .cornerRadius(16)
                            .shadow(radius: 10)
                            .clipped()
                            .allowsHitTesting(false)
                            .onReceive(Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()) { _ in
                                // Simple video playback maintenance
                                if shouldKeepPlaying && player.timeControlStatus != .playing {
                                    if let duration = player.currentItem?.duration,
                                       player.currentTime() < duration {
                                        player.play()
                                        print("🔄 Keeping video playing")
                                    } else {
                                        shouldKeepPlaying = false
                                        print("🎬 Video completed")
                                    }
                                }
                            }
                    } else {
                        // Loading state
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(width: 600, height: 400)
                            .cornerRadius(16)
                            .overlay(
                                VStack(spacing: 8) {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                    Text("Loading video...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            )
                    }
                }
                
                // Horizontal Role Selection
                VStack(spacing: 16) {
                    Text("Choose your role to get started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .opacity(showRoles ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.0), value: showRoles)
                    
                    HStack(spacing: 20) {
                        ForEach(Array(UserRole.allCases.enumerated()), id: \.element) { index, role in
                            HorizontalRoleCard(role: role) {
                                appState.userRole = role
                                appState.login(as: role)
                            }
                            .opacity(showRoles ? 1.0 : 0.0)
                            .offset(y: showRoles ? 0 : 30)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.2),
                                value: showRoles
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Text("Empowering educators, parents, and counselors")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7)) // Changed to white for black background
                        .opacity(showRoles ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.0).delay(1.0), value: showRoles)
                    
                    HStack(spacing: 20) {
                        Button("Privacy Policy") {
                            // Handle privacy policy
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                        
                        Button("Terms of Service") {
                            // Handle terms
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                    }
                    .opacity(showRoles ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(1.2), value: showRoles)
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            setupVideoPlayer()
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    private func setupVideoPlayer() {
        // Try to load the video from Resources
        guard let videoURL = Bundle.main.url(forResource: "intro_video", withExtension: "MP4") else {
            print("❌ Video file 'intro_video.mp4' not found in Resources")
            // List what files are actually in the bundle
            if let resourcePath = Bundle.main.resourcePath {
                do {
                    let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    print("📁 Files in bundle: \(files.filter { $0.hasSuffix(".MP4") || $0.hasSuffix(".mov") })")
                } catch {
                    print("Error listing bundle: \(error)")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                startAnimationSequence()
            }
            return
        }
        
        print("✅ Found video file at: \(videoURL)")
        
        // Create player using modern AVURLAsset (no deprecation warning)
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        // Set player properties for autoplay and continuous playback
        player?.automaticallyWaitsToMinimizeStalling = false
        player?.isMuted = false
        player?.preventsDisplaySleepDuringVideoPlayback = true
        
        // Ensure video continues playing during UI updates
        player?.actionAtItemEnd = .pause // Don't loop, just pause at end
        
        // Use async/await style status monitoring
        Task {
            await monitorPlayerStatus(playerItem: playerItem)
        }
        
        // Set up video end notification (no looping)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            shouldKeepPlaying = false
            print("🎬 Video finished playing")
            // Video will stop here - no looping
        }
        
        // Try immediate play in case it's already ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if playerItem.status == .readyToPlay {
                self.videoLoaded = true
                self.player?.play()
                self.startAnimationSequence()
                print("🎬 Video immediately ready")
            }
        }
        
        // Fallback timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if !self.videoLoaded {
                print("⚠️ Video loading timeout - check file format and encoding")
                self.startAnimationSequence()
            }
        }
    }
    
    private func monitorPlayerStatus(playerItem: AVPlayerItem) async {
        // Monitor status changes
        for await status in playerItem.publisher(for: \.status).values {
            await MainActor.run {
                switch status {
                case .readyToPlay:
                    if !videoLoaded {
                        videoLoaded = true
                        player?.play()
                        startAnimationSequence()
                        print("📹 Video ready to play - starting now")
                    }
                case .failed:
                    if let error = playerItem.error {
                        print("❌ Video failed: \(error.localizedDescription)")
                    }
                    startAnimationSequence()
                case .unknown:
                    print("🤔 Video status unknown")
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func startAnimationSequence() {
        // Start app name fade-in after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showAppName = true
        }
        
        // Start role selection fade-in after video duration (5 seconds total)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            showRoles = true
        }
    }
}

// Horizontal Role Card for compact layout
struct HorizontalRoleCard: View {
    let role: UserRole
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: role.icon)
                    .font(.system(size: 32))
                    .foregroundColor(role.color)
                    .frame(width: 60, height: 60)
                    .background(role.color.opacity(0.1))
                    .cornerRadius(30)
                
                VStack(spacing: 4) {
                    Text(role.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(shortDescription(for: role))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(width: 120, height: 140)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func shortDescription(for role: UserRole) -> String {
        switch role {
        case .parent:
            return "Track progress & collaborate"
        case .teacher:
            return "Analyze & implement IEPs"
        case .counselor:
            return "Coordinate & support"
        }
    }
}

// Debug version to help troubleshoot video issues
struct DebugLandingScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var player: AVPlayer?
    @State private var debugInfo: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SpectrumEdge")
                .font(.system(size: 48, weight: .black, design: .default))
                .foregroundColor(.black)
            
            // Video area
            VStack {
                if let player = player {
                    VideoPlayer(player: player)
                        .frame(width: 320, height: 180)
                        .cornerRadius(16)
                        .onAppear {
                            player.play()
                            debugInfo.append("Video player created and play() called")
                        }
                } else {
                    Rectangle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 320, height: 180)
                        .cornerRadius(16)
                        .overlay(
                            Text("No Video Player")
                                .foregroundColor(.red)
                        )
                }
            }
            
            // Debug info
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Debug Info:")
                        .font(.headline)
                    ForEach(Array(debugInfo.enumerated()), id: \.offset) { index, info in
                        Text("\(index + 1). \(info)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .frame(height: 150)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Button("Test Video Loading") {
                setupVideoPlayer()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            setupVideoPlayer()
        }
    }
    
    private func setupVideoPlayer() {
        debugInfo.append("setupVideoPlayer() called")
        
        // Check if video file exists
        if let videoURL = Bundle.main.url(forResource: "intro_video", withExtension: "MP4") {
            debugInfo.append("✅ Found video at: \(videoURL.lastPathComponent)")
            
            let asset = AVURLAsset(url: videoURL, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            
            debugInfo.append("AVPlayer created")
            
            // Try to play immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                player?.play()
                debugInfo.append("play() called")
            }
            
        } else {
            debugInfo.append("❌ Video file 'intro_video.mp4' not found in Bundle")
            
            // List all files in bundle
            if let resourcePath = Bundle.main.resourcePath {
                do {
                    let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    debugInfo.append("Files in bundle: \(files.joined(separator: ", "))")
                } catch {
                    debugInfo.append("Error listing bundle contents: \(error)")
                }
            }
        }
    }
}
