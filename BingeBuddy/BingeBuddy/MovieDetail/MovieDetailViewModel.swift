import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var detail: DetailedTitleDTO?

    let movieID: String

    init(movieID: String) {
        self.movieID = movieID
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            detail = try await fetchDetail(for: movieID)
        } catch {
            errorMessage = "Failed to load details."
            print("MovieDetail load error:", error)
        }
    }

    func clearError() {
        errorMessage = nil
    }

    // MARK: - Derived UI helpers

    var titleText: String {
        detail?.primaryTitle ?? detail?.originalTitle ?? "Untitled"
    }

    var posterURL: URL? {
        if let urlString = detail?.primaryImage?.url {
            return URL(string: urlString)
        }
        return nil
    }

    var yearText: String? {
        if let y = detail?.startYear {
            return String(y)
        }
        return nil
    }

    var runtimeText: String? {
        guard let seconds = detail?.runtimeSeconds else { return nil }
        let minutes = seconds / 60
        if minutes > 0 {
            return "\(minutes) min"
        } else {
            return "\(seconds) sec"
        }
    }

    var genresText: String? {
        let genres = detail?.genres ?? []
        return genres.isEmpty ? nil : genres.joined(separator: " • ")
    }

    var ratingText: String? {
        guard let rating = detail?.rating?.aggregateRating else { return nil }
        return String(format: "%.1f", rating)
    }

    var plotText: String? {
        detail?.plot
    }

    var directorsText: String? {
        guard let names = detail?.directors?.compactMap({ $0.displayName }), !names.isEmpty else { return nil }
        return names.joined(separator: ", ")
    }

    var writersText: String? {
        guard let names = detail?.writers?.compactMap({ $0.displayName }), !names.isEmpty else { return nil }
        return names.joined(separator: ", ")
    }

    var actorsText: String? {
        guard let names = detail?.stars?.compactMap({ $0.displayName }), !names.isEmpty else { return nil }
        return names.joined(separator: ", ")
    }

    // MARK: - Networking

    private func fetchDetail(for id: String) async throws -> DetailedTitleDTO {
        guard let components = URLComponents(string: "https://api.imdbapi.dev/titles/\(id)") else {
            throw URLError(.badURL)
        }

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

        guard http.statusCode != 404 else {
            throw URLError(.resourceUnavailable)
        }

        guard http.statusCode != 500 else {
            throw URLError(.cannotConnectToHost)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        do {
            return try decoder.decode(DetailedTitleDTO.self, from: data)
        } catch {
            throw URLError(.cannotDecodeContentData)
        }
    }
}
