import Foundation
import Combine

@MainActor
final class PersonFilmographyViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var credits: [NameCreditDTO] = []

    let personID: String
    let personName: String?

    init(personID: String, personName: String? = nil) {
        self.personID = personID
        self.personName = personName
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let fetched = try await fetchFilmography(for: personID)
            credits = fetched.credits ?? []
        } catch {
            errorMessage = "Failed to load filmography."
            #if DEBUG
            print("Filmography load error:", error)
            #endif
        }
    }

    private func fetchFilmography(for id: String) async throws -> NamesFilmographyResponse {
        let base = "https://api.imdbapi.dev/names/"
        guard let url = URL(string: base + id + "/filmography") else {
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
        return try decoder.decode(NamesFilmographyResponse.self, from: data)
    }

    // Show each title only once by deduplicating on the title id (preserving order).
    var movies: [Movie] {
        var seen = Set<String>()
        var result: [Movie] = []
        for credit in credits {
            let t = credit.title
            guard let id = t.id, !seen.contains(id) else { continue }
            seen.insert(id)
            let title = t.primaryTitle ?? t.originalTitle ?? "Untitled"
            let genre = t.genres?.first ?? "Unknown"
            let posterURL = URL(string: t.primaryImage?.url ?? "")
            result.append(Movie(id: id, title: title, genre: genre, posterAssetName: nil, posterURL: posterURL))
        }
        return result
    }

    var navTitle: String {
        if let name = personName, !name.isEmpty {
            return "\(name) • Filmography"
        } else {
            return "Filmography"
        }
    }
}
