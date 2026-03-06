import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var listsStore: LocalMovieLists
    
    var body: some View {
        TabView {
            // Tab 1: Your Lists
            NavigationStack {
                YourListsTabView(viewModel: viewModel)
                    .withMovieDestinations()
            }
            .tabItem {
                Label("Your Lists", systemImage: "list.bullet")
            }
            
            // Tab 2: Most Popular Movies
            NavigationStack {
                PopularTabView(viewModel: viewModel)
                    .withMovieDestinations()
            }
            .tabItem {
                Label("Popular", systemImage: "star.fill")
            }
            
            // Tab 3: Custom Movies (CRUD)
            NavigationStack {
                CustomMoviesView()
                    .withMovieDestinations()
            }
            .tabItem {
                Label("Custom", systemImage: "square.and.pencil")
            }
            
            // Tab 4: Search
            NavigationStack {
                SearchTabView(viewModel: viewModel)
                    .withMovieDestinations()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            // Tab 5: Nearby Cinemas (MapKit)
            NearbyCinemasView()
                .tabItem {
                    Label("Cinemas", systemImage: "map")
                }
        }
        .task {
            await viewModel.load()
        }
    }
    
}

// MARK: - Reusable destinations

private struct MovieDestinations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Movie.self) { movie in
                if movie.id.hasPrefix("tt-") {
                    MovieDetailView(movieID: movie.id)
                } else {
                    CustomMovieDetailView(movie: movie)
                }
            }
            .navigationDestination(for: String.self) { movieID in
                MovieDetailView(movieID: movieID)
            }
    }
}

private extension View {
    func withMovieDestinations() -> some View {
        modifier(MovieDestinations())
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
