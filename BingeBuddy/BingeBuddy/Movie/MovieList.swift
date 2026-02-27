import Foundation

struct MovieList: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var movieIDs: Set<String> = []

    mutating func toggle(movieID: String) {
        if movieIDs.contains(movieID) {
            movieIDs.remove(movieID)
        } else {
            movieIDs.insert(movieID)
        }
    }

    func contains(_ movieID: String) -> Bool {
        movieIDs.contains(movieID)
    }
}
