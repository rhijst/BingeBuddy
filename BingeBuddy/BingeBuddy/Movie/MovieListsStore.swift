import Foundation
import SwiftUI
import Combine

@MainActor
final class MovieListsStore: ObservableObject {
    @AppStorage("customMovieLists") private var storedData: Data = Data()

    @Published private(set) var lists: [MovieList] = []

    init() {
        load()
        if lists.isEmpty {
            lists = [
                MovieList(name: "Watchlist"),
                MovieList(name: "Favorites")
            ]
            persist()
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

    private func persist() {
        do {
            storedData = try JSONEncoder().encode(lists)
        } catch {
            // Handle encoding error if needed
        }
    }

    func createList(named name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        lists.append(MovieList(name: trimmed))
        persist()
    }

    func deleteLists(at offsets: IndexSet) {
        lists.remove(atOffsets: offsets)
        persist()
    }

    func renameList(id: UUID, to newName: String) {
        guard let idx = lists.firstIndex(where: { $0.id == id }) else { return }
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        lists[idx].name = trimmed
        persist()
    }

    func toggle(movieID: String, in listID: UUID) {
        guard let idx = lists.firstIndex(where: { $0.id == listID }) else { return }
        lists[idx].toggle(movieID: movieID)
        persist()
    }

    func contains(movieID: String, in listID: UUID) -> Bool {
        guard let list = lists.first(where: { $0.id == listID }) else { return false }
        return list.contains(movieID)
    }
}
