import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var listsStore: LocalMovieLists
    
    var body: some View {
        NavigationStack {
            TabView {
                // Tab 1: Your Lists
                YourListsTabView(viewModel: viewModel)
                    .tabItem {
                        Label("Your Lists", systemImage: "list.bullet")
                    }
                
                // Tab 2: Most Popular Movies
                PopularTabView(viewModel: viewModel)
                    .tabItem {
                        Label("Popular", systemImage: "star.fill")
                    }
                
                // Tab 3: Custom Movies (CRUD)
                CustomMoviesView()
                    .tabItem {
                        Label("Custom", systemImage: "square.and.pencil")
                    }
                
                // Tab 4: Search (inline search bar like CustomMoviesView)
                SearchTabView(viewModel: viewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
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
    
    // Map stored IDs in a list to lightweight Movie values for display.
    // Prefer resolving from the fetched feed so we get poster/title/genre;
    // fallback to cached metadata; finally placeholders.
    func getLocalMovies(from list: MovieList) -> [Movie] {
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

struct SectionHeader: View {
    let title: String
    let size: CGFloat
    
    init(_ title: String, size: CGFloat = 18) {
        self.title = title
        self.size = size
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(.primary)
            .accessibilityAddTraits(.isHeader)
    }
}


#Preview {
    HomeView()
        .environmentObject(LocalMovieLists())
        .environmentObject(CustomMoviesStore())
}

