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
            // Map API DTOs to the Movie model
            let mapped: [Movie] = fetched.map { dto in
                return mapToMovie(dto: dto)
            }
            self.movies = mapped
        } catch {
            print("Failed to load titles: \(error)")
        }
    }

    // Helper function to map DTO to Movie
    private func mapToMovie(dto: TitleDTO) -> Movie {
        let genre = dto.genres?.first ?? "Unknown"
        
        // Safely create poster URL (only if URL string is not empty or valid)
        var posterURL: URL? = URL(string: "")
        if let urlString = dto.primaryImage?.url, let newURL = URL(string: urlString) {
            posterURL = newURL
        } else {
            print("Invalid or missing poster URL. -- " + (dto.primaryImage?.url ?? "No url provided") + " --")
        }

        return Movie(
            id: dto.id ?? "tt0133093",
            title: dto.primaryTitle ?? dto.originalTitle ?? "Untitled",
            genre: genre,
            posterAssetName: nil,
            posterURL: posterURL
        )
    }

    // MARK: - Networking

    private func fetchPopularTitles() async throws -> [TitleDTO] {
        guard var components = URLComponents(string: "https://api.imdbapi.dev/titles") else {
            throw URLError(.badURL)
        }
        
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

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Check for status code 2xx range
        guard (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse, userInfo: ["statusCode": http.statusCode])
        }
        
        // Optionally, you can check for specific status codes if needed, e.g.
        guard http.statusCode != 404 else {
            throw URLError(.resourceUnavailable)
        }
        
        guard http.statusCode != 500 else {
            throw URLError(.cannotConnectToHost)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        do {
            let root = try decoder.decode(TitlesResponse.self, from: data)
            return root.titles ?? []
        } catch {
            //TODO: return empty array and handle exeption gracefully instead of throwing error
            throw URLError(.cannotDecodeContentData)
        }
    }
}
