import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var listsStore: LocalMovieLists

    var body: some View {
        NavigationStack {
            TabView {
                // Tab 1: Your Lists
                ScrollView {
                    if viewModel.isLoading {
                        SkeletonHomeView()
                            .padding(.top, 8)
                            .accessibilityHidden(true)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            sectionHeader("Your Lists", size: 30)
                                .padding(.horizontal, 16)

                            if listsStore.lists.isEmpty {
                                Text("You don't have any lists yet.")
                                    .padding(.horizontal, 16)
                            } else {
                                ForEach(listsStore.lists) { list in
                                    let moviesForList = getLocalMovies(from: list)
                                    if !moviesForList.isEmpty {
                                        MovieHorizontalScrollView(title: list.name, movies: moviesForList)
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .tabItem {
                    Label("Your Lists", systemImage: "list.bullet")
                }

                // Tab 2: Most Popular Movies
                ScrollView {
                    if viewModel.isLoading {
                        SkeletonHomeView()
                            .padding(.top, 8)
                            .accessibilityHidden(true)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            sectionHeader("Most Popular Movies", size: 30)
                                .padding(.horizontal, 16)

                            if viewModel.groupedMovies.count <= 0 {
                                Text("Something went wrong loading the movies... Please try again later.")
                                    .padding(.horizontal, 16)
                            }

                            ForEach(viewModel.groupedMovies, id: \.genre) { group in
                                MovieHorizontalScrollView(title: group.genre, movies: group.movies)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .tabItem {
                    Label("Popular", systemImage: "star.fill")
                }

                // Tab 3: Custom Movies (CRUD)
                CustomMoviesView()
                    .tabItem {
                        Label("Custom", systemImage: "square.and.pencil")
                    }
            }
            .task {
                await viewModel.load()
            }
            .navigationDestination(for: String.self) { movieID in
                MovieDetailView(movieID: movieID)
            }
        }
    }

    // Helper function to keep section headers consistent
    @ViewBuilder
    private func sectionHeader(_ title: String, size: CGFloat = 18) -> some View {
        Text(title)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(.primary)
            .accessibilityAddTraits(.isHeader)
    }

    // Map stored IDs in a list to lightweight Movie values for display.
    // Prefer resolving from the fetched feed so we get poster/title/genre;
    // fallback to cached metadata; finally placeholders.
    private func getLocalMovies(from list: MovieList) -> [Movie] {
        // Build a quick lookup from fetched movies by id
        let indexByID = Dictionary(
            uniqueKeysWithValues: viewModel.movies.map { ($0.id, $0) }
        )

        let sortedIDs = list.movieIDs.sorted()

        return sortedIDs.compactMap { id in
            if let resolved = indexByID[id] {
                return resolved
            } else if let cached = listsStore.cachedMoviesByID[id] {
                return Movie(
                    id: cached.id,
                    title: cached.title,
                    genre: cached.genre,
                    posterAssetName: nil,
                    posterURL: cached.posterURLString.flatMap(URL.init(string:))
                )
            } else {
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
        .environmentObject(LocalMovieLists())
        .environmentObject(CustomMoviesStore())
}
