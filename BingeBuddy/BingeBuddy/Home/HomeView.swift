import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var listsStore = MovieListsStore()

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    SkeletonHomeView()
                        .padding(.top, 8)
                        .accessibilityHidden(true)
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        // Your Lists section
                        if !listsStore.lists.isEmpty {
                            sectionHeader("Your Lists",size: 30)
                                .padding(.horizontal, 16)

                            ForEach(listsStore.lists) { list in
                                let moviesForList = movies(from: list)
                                if !moviesForList.isEmpty {
                                    MovieSectionView(title: list.name, movies: moviesForList)
                                }
                            }

                            Divider()
                                .padding(.horizontal, 16)
                                .padding(.top, 4)
                        }

                        // Popular section
                        sectionHeader("Most Popular Movies",size: 30)
                            .padding(.horizontal, 16)

                        // Existing genre sections
                        ForEach(viewModel.groupedMovies, id: \.genre) { group in
                            MovieSectionView(title: group.genre, movies: group.movies)
                        }
                    }
                    .padding(.top, 8)
                    .animation(.default, value: viewModel.movies.count)
                }
            }
            .task {
                await viewModel.load()
            }
            // Define navigation destinations at the NavigationStack level
            .navigationDestination(for: String.self) { movieID in
                MovieDetailView(movieID: movieID)
            }
        }
    }

    // A small helper to keep section headers consistent
    @ViewBuilder
    private func sectionHeader(_ title: String, size: CGFloat = 18) -> some View {
        Text(title)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(.primary)
            .accessibilityAddTraits(.isHeader)
    }

    // Map stored IDs in a list to lightweight Movie values for display.
    // Prefer resolving from the fetched feed so we get poster/title/genre;
    // fallback to placeholders if not present.
    private func movies(from list: MovieList) -> [Movie] {
        // Build a quick lookup from fetched movies by id
        let indexByID: [String: Movie] = Dictionary(uniqueKeysWithValues:
            viewModel.movies.compactMap { movie in
                guard let id = movie.id else { return nil }
                return (id, movie)
            }
        )

        // Preserve insertion order deterministically by sorting IDs
        let sortedIDs = list.movieIDs.sorted()

        // Map to Movie values the UI can render
        return sortedIDs.compactMap { id in
            if let resolved = indexByID[id] {
                return resolved
            } else {
                // Fallback minimal Movie so poster shows placeholder and navigation works
                return Movie(
                    id: id,
                    title: "Unknown",
                    genre: "My List",
                    posterAssetName: nil,
                    posterURL: nil
                )
            }
        }
    }
}

#Preview {
    HomeView()
}
