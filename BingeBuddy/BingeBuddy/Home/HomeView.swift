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
            // New routing based on full Movie value
            .navigationDestination(for: Movie.self) { movie in
                if movie.id.hasPrefix("tt") {
                    MovieDetailView(movieID: movie.id)
                } else {
                    CustomMovieDetailView(movie: movie)
                }
            }
            // Keep existing String destination if something else still links by ID
            .navigationDestination(for: String.self) { movieID in
                MovieDetailView(movieID: movieID)
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
