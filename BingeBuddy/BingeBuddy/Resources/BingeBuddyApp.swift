import SwiftUI

@main
struct BingeBuddyApp: App {
    @State private var showSplash = true
    @StateObject private var listsStore = LocalMovieLists()
    @StateObject private var customMoviesStore = CustomMoviesStore()

    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView()
                    .opacity(showSplash ? 0 : 1)
                    .environmentObject(listsStore)
                    .environmentObject(customMoviesStore)

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(1200))
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
