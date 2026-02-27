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

#Preview {
    ContentView()
}
