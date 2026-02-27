import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading: Bool = false

    // Group based on category
    var groupedMovies: [(genre: String, movies: [Movie])] {
        let groups = Dictionary(grouping: movies, by: { $0.genre })
        // Sort alphabetical
        return groups.keys.sorted().map { key in
            (genre: key, movies: groups[key] ?? [])
        }
    }

    func load() async {
        guard movies.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let fetched = try await fetchPopularTitles()
            // Map API DTOs to your Movie model
            let mapped: [Movie] = fetched.flatMap { dto in
                // Choose first genre if available; otherwise use "Unknown"
                let genre = dto.genres?.first ?? "Unknown"
                let posterURL = URL(string: dto.primaryImage?.url ?? "")
                return [
                    Movie(
                        id: dto.id ?? "tt0133093",
                        title: dto.primaryTitle ?? dto.originalTitle ?? "Untitled",
                        genre: genre,
                        posterAssetName: nil,
                        posterURL: posterURL
                    )
                ]
            }
            self.movies = mapped
        } catch {
            // In case of failure, you might want to log or show an error state
            // For now, leave movies empty
            print("Failed to load titles: \(error)")
        }
    }

    // MARK: - Networking

    private func fetchPopularTitles() async throws -> [TitleDTO] {
        var components = URLComponents(string: "https://api.imdbapi.dev/titles")!
        components.queryItems = [
            URLQueryItem(name: "sortBy", value: "SORT_BY_POPULARITY")
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        let root = try decoder.decode(TitlesResponse.self, from: data)
        return root.titles ?? []
    }
}

// MARK: - API DTOs

private struct TitlesResponse: Decodable {
    let titles: [TitleDTO]?
}

private struct TitleDTO: Decodable {
    let id: String?
    let type: String?
    let primaryTitle: String?
    let originalTitle: String?
    let primaryImage: PrimaryImageDTO?
    let startYear: Int?
    let endYear: Int?
    let runtimeSeconds: Int?
    let genres: [String]?
    let rating: RatingDTO?
    let plot: String?
}

private struct PrimaryImageDTO: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
}

private struct RatingDTO: Decodable {
    let aggregateRating: Double?
    let voteCount: Int?
}
