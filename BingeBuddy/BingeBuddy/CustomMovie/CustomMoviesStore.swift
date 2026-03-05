import Foundation
import SwiftUI
import Combine

@MainActor
final class CustomMoviesStore: ObservableObject {
    @AppStorage("customMovies") private var storedData: Data = Data()
    @Published private(set) var movies: [Movie] = []

    init() {
        load()
    }

    func load() {
        if !storedData.isEmpty, let decoded = try? JSONDecoder().decode([Movie].self, from: storedData) {
            movies = decoded
            return
        }
        movies = []
    }

    private func persist() {
        do {
            storedData = try JSONEncoder().encode(movies)
        } catch {
            // Handle encoding error if needed
        }
    }

    // CRUD
    func create(
        title: String,
        genre: String?,
        notes: String?,
        posterURLString: String?,
        plot: String?,
        directorsCSV: String?,
        writersCSV: String?,
        actorsCSV: String?
    ) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let id = "custom-\(UUID().uuidString)"
        let url = posterURLString?.nilIfBlank.flatMap(URL.init(string:))
        let directors = directorsCSV?.splitAndTrim()
        let writers = writersCSV?.splitAndTrim()
        let actors = actorsCSV?.splitAndTrim()

        let item = Movie(
            id: id,
            title: trimmed,
            genre: (genre?.nilIfBlank) ?? "",
            posterAssetName: nil,
            posterURL: url,
            notes: notes?.nilIfBlank,
            plot: plot?.nilIfBlank,
            directors: directors?.isEmpty == true ? nil : directors,
            writers: writers?.isEmpty == true ? nil : writers,
            actors: actors?.isEmpty == true ? nil : actors
        )
        movies.append(item)
        persist()
    }

    func update(_ movie: Movie) {
        guard let idx = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        movies[idx] = movie
        persist()
    }

    func delete(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
        persist()
    }

    func delete(_ movie: Movie) {
        guard let idx = movies.firstIndex(of: movie) else { return }
        movies.remove(at: idx)
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        movies.move(fromOffsets: source, toOffset: destination)
        persist()
    }
}

// Temporary type for migration from old storage
private struct LegacyCustomMovie: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var genre: String?
    var notes: String?
    var posterURLString: String?
}

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    func splitAndTrim(separator: Character = ",") -> [String] {
        return self
            .split(separator: separator)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
    }
}
