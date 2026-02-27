import SwiftUI

struct HomeView: View {
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
                            MovieSectionView(title: group.genre, movies: group.movies)
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
            // Define navigation destinations at the NavigationStack level
            .navigationDestination(for: String.self) { movieID in
                MovieDetailView(movieID: movieID)
            }
        }
    }
}
