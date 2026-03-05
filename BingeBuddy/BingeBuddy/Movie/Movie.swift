import Foundation

struct Movie: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let genre: String

    // PosterAssetName: if there is no online poster, use cached variant (local use)
    let posterAssetName: String?
    let posterURL: URL?

    // Custom-only fields (optional for API-provided movies)
    let notes: String?

    // local-only metadata for custom movies
    let plot: String?
    let directors: [String]?
    let writers: [String]?
    let actors: [String]?

    init(
        id: String,
        title: String,
        genre: String,
        posterAssetName: String? = nil,
        posterURL: URL? = nil,
        notes: String? = nil,
        plot: String? = nil,
        directors: [String]? = nil,
        writers: [String]? = nil,
        actors: [String]? = nil
    ) {
        self.id = id
        self.title = title
        self.genre = genre
        self.posterAssetName = posterAssetName
        self.posterURL = posterURL
        self.notes = notes
        self.plot = plot
        self.directors = directors
        self.writers = writers
        self.actors = actors
    }
}
