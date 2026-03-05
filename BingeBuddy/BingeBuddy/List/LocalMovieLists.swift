import Foundation
import SwiftUI
import Combine

@MainActor
final class LocalMovieLists: ObservableObject {
    @AppStorage("customMovieLists") private var storedData: Data = Data()
    @AppStorage("cachedMoviesByID") private var cachedMoviesData: Data = Data()

    @Published private(set) var lists: [MovieList] = []
    @Published private(set) var cachedMoviesByID: [String: CachedMovie] = [:]

    init() {
        load()
        loadCache()
        if lists.isEmpty {
            lists = [
                MovieList(name: "Watchlist"),
                MovieList(name: "Favorites")
            ]
            saveListsToLocalStorage()
        }
    }

    func load() {
        if storedData.isEmpty {
            lists = []
            return
        }
        do {
            let decoded = try JSONDecoder().decode([MovieList].self, from: storedData)
            lists = decoded
        } catch {
            lists = []
        }
    }

    private func loadCache() {
        guard !cachedMoviesData.isEmpty else {
            cachedMoviesByID = [:]
            return
        }
        do {
            cachedMoviesByID = try JSONDecoder().decode([String: CachedMovie].self, from: cachedMoviesData)
        } catch {
            cachedMoviesByID = [:]
        }
    }

    private func saveListsToLocalStorage() {
        do {
            storedData = try JSONEncoder().encode(lists)
        } catch {
            print("Failed saving list to storage")
        }
    }

    private func persistCache() {
        do {
            cachedMoviesData = try JSONEncoder().encode(cachedMoviesByID)
        } catch {
            print("Failed caching movies")
        }
    }

    func createList(named name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        lists.append(MovieList(name: trimmed))
        saveListsToLocalStorage()
    }

    func deleteLists(at offsets: IndexSet) {
        lists.remove(atOffsets: offsets)
        saveListsToLocalStorage()
    }

    func renameList(id: UUID, to newName: String) {
        guard let idx = lists.firstIndex(where: { $0.id == id }) else { return }
        
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        lists[idx].name = trimmed
        saveListsToLocalStorage()
    }

    func toggle(movieID: String, in listID: UUID) {
        guard let idx = lists.firstIndex(where: { $0.id == listID }) else { return }
        
        lists[idx].toggle(movieID: movieID)
        saveListsToLocalStorage()
    }

    func contains(movieID: String, in listID: UUID) -> Bool {
        guard let list = lists.first(where: { $0.id == listID }) else { return false }
        return list.contains(movieID)
    }

    // MARK: - Metadata cache

    func updateInsertCachedMovie(id: String, title: String, genre: String = "My List", posterURL: URL?) {
        let cached = CachedMovie(
            id: id,
            title: title,
            genre: genre,
            posterURLString: posterURL?.absoluteString
        )
        cachedMoviesByID[id] = cached
        persistCache()
    }

    func removeCachedMovie(id: String) {
        cachedMoviesByID.removeValue(forKey: id)
        persistCache()
    }
}
