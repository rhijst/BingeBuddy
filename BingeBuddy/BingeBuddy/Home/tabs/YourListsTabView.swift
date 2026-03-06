import SwiftUI

struct YourListsTabView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject private var listsStore: LocalMovieLists
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                SkeletonHomeView()
                    .padding(.top, 8)
                    .accessibilityHidden(true)
            } else {
                LazyVStack(alignment: .leading, spacing: 20) {
                    SectionHeader("Your Lists", size: 30)
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

