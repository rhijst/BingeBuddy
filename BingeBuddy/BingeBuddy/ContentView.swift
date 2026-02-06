import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    SkeletonHomeView()
                        .padding(.top, 8)
                        .accessibilityHidden(true)
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.groupedMovies, id: \.genre) { group in
                            VStack(alignment: .leading, spacing: 12) {
                                
                                // Title
                                Text(group.genre)
                                    .font(.title3.weight(.semibold))
                                    .padding(.horizontal, 16)

                                // Posters
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 12) {
                                        ForEach(group.movies) { movie in
                                            MoviePosterView(movie: movie)
                                                .frame(width: 120)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                    .padding(.top, 8)
                    .animation(.default, value: viewModel.movies.count)
                }
            }
            .navigationTitle("Binge Buddy")
            .task {
                await viewModel.load()
            }
        }
    }
}

private struct MoviePosterView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Poster
            ZStack {
                // Placeholder achtergrond
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .aspectRatio(2/3, contentMode: .fit)
                    .overlay(
                        Group {
                            if let assetName = movie.posterAssetName {
                                Image(assetName)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                // Als er geen lokale asset is, kan hier later een AsyncImage met URL komen
                                Image(systemName: "film")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(24)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    )
                    .clipped()
                    .cornerRadius(8)
            }

            // Titel
            Text(movie.title)
                .font(.caption)
                .lineLimit(1)
                .foregroundStyle(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(movie.title)
    }
}

// MARK: - Skeleton Views

private struct SkeletonHomeView: View {
    // Show 3–4 sections with a few placeholder cards each
    private let sectionCount = 4
    private let itemsPerRow = 6

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(0..<sectionCount, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 12) {
                    // Fake section title
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 18)
                        .padding(.horizontal, 16)
                        .shimmer() // shimmer per element

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(0..<itemsPerRow, id: \.self) { _ in
                                SkeletonPosterCard()
                                    .frame(width: 120)
                                    .shimmer()
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .redacted(reason: .placeholder)
    }
}

private struct SkeletonPosterCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(2/3, contentMode: .fit)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 12)
                .padding(.trailing, 24)
        }
    }
}

// Simple shimmer effect
private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    GeometryReader { geo in
                        // Softer, wider beam with smooth falloff
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

                        // Beam width relative to element size
                        let beamWidth = geo.size.width * 0.4 // Adjust this to control the shimmer size
                        let initialOffset = -beamWidth

                        Rectangle()
                            .fill(gradient)
                            .frame(width: beamWidth)
                            .rotationEffect(.degrees(20))
                            .offset(x: phase * geo.size.width + initialOffset) // Adjust the shimmer's starting point
                            .blur(radius: 10) // soften edges of the beam
                            .blendMode(.plusLighter)
                            // Mask to the element bounds to avoid hard square outline
                            .mask(
                                Rectangle()
                                    .cornerRadius(8) // match typical skeleton corner
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

private extension View {
    func shimmer(_ active: Bool = true) -> some View {
        modifier(ShimmerModifier(isActive: active))
    }
}

#Preview {
    ContentView()
}
