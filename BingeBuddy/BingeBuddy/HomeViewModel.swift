import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading: Bool = false

    // Groep based on categorie
    var groupedMovies: [(genre: String, movies: [Movie])] {
        let groups = Dictionary(grouping: movies, by: { $0.genre })
        // Sort alphbetical
        return groups.keys.sorted().map { key in
            (genre: key, movies: groups[key] ?? [])
        }
    }

    func load() async {
        guard movies.isEmpty else { return }
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(for: .milliseconds(6000))
        self.movies = Self.mockMovies()
        isLoading = false
    }

    private static func mockMovies() -> [Movie] {
        let genres = ["Action", "Sci‑Fi", "Drama", "Comedy"]
        
        var items: [Movie] = []
        for (gIndex, genre) in genres.enumerated() {
            for idx in 1...8 {
                let titleSuffix = idx == 1 ? "" : " • \(idx)"
                let title = (genre == "Sci‑Fi" ? "The Matrix" : "\(genre) Title") + titleSuffix
                items.append(
                    Movie(
                        title: title,
                        genre: genre,
                        posterAssetName: "matrix",
                        posterURL: nil
                    )
                )
            }
        }
        return items
    }
}
