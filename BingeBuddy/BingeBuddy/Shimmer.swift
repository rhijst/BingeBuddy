import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    GeometryReader { geo in
                        let gradient = LinearGradient(
                            colors: [
                                .clear,
                                Color.white.opacity(0.02),
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.20),
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.08),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        let beamWidth = geo.size.width * 0.4
                        let initialOffset = -beamWidth

                        Rectangle()
                            .fill(gradient)
                            .frame(width: beamWidth)
                            .rotationEffect(.degrees(20))
                            .offset(x: phase * geo.size.width + initialOffset)
                            .blur(radius: 10)
                            .blendMode(.plusLighter)
                            .mask(
                                Rectangle()
                                    .cornerRadius(8)
                            )
                            .animation(
                                .linear(duration: 1.6).repeatForever(autoreverses: false),
                                value: phase
                            )
                            .onAppear { phase = 1 }
                    }
                    .allowsHitTesting(false)
                }
            }
    }
}

extension View {
    func shimmer(_ active: Bool = true) -> some View {
        modifier(ShimmerModifier(isActive: active))
    }
}
