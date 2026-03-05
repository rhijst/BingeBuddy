import Foundation
import SwiftUI
import Combine

@MainActor
final class CustomMoviesStore: ObservableObject {
    @AppStorage("customMovies") private var storedData: Data = Data()
    @Published private(set) var movies: [CustomMovie] = []

    init() {
        load()
    }

    func load() {
        guard !storedData.isEmpty else {
            movies = []
            return
        }
        do {
            movies = try JSONDecoder().decode([CustomMovie].self, from: storedData)
        } catch {
            movies = []
        }
    }

    private func persist() {
        do {
            storedData = try JSONEncoder().encode(movies)
        } catch {
            // Handle encoding error if needed
        }
    }

    // CRUD
    func create(title: String, genre: String?, notes: String?, posterURLString: String?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let item = CustomMovie(title: trimmed, genre: genre?.nilIfBlank, notes: notes?.nilIfBlank, posterURLString: posterURLString?.nilIfBlank)
        movies.append(item)
        persist()
    }

    func update(_ movie: CustomMovie) {
        guard let idx = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        movies[idx] = movie
        persist()
    }

    func delete(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
        persist()
    }

    func delete(_ movie: CustomMovie) {
        guard let idx = movies.firstIndex(of: movie) else { return }
        movies.remove(at: idx)
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        movies.move(fromOffsets: source, toOffset: destination)
        persist()
    }
}

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
