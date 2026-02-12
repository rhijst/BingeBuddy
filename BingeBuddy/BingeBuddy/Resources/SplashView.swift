import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color(red: 155	 / 255, green: 230 / 255, blue: 241 / 255)

                .ignoresSafeArea()

            Image("tv")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 200)
                .scaleEffect(scale)
                .opacity(opacity)
                .accessibilityHidden(true)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 1.0
                scale = 1.0
            }
        }
    }
}

#Preview {
    SplashView()
}
