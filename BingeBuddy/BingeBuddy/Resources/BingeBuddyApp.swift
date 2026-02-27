import SwiftUI

@main
struct BingeBuddyApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView()
                    .opacity(showSplash ? 0 : 1)

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Keep splash for a short time, then fade out
                Task { @MainActor in
                    // Minimum visible time
                    try? await Task.sleep(for: .milliseconds(1200))
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
