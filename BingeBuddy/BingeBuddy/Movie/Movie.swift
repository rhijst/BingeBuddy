import Foundation

struct Movie: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let genre: String

    // PosterAssetName: if there is no online poster, use cached variant (local use)
    let posterAssetName: String?
    let posterURL: URL?

    // Custom-only field (optional for API-provided movies)
    let notes: String?

    init(
        id: String,
        title: String,
        genre: String,
        posterAssetName: String? = nil,
        posterURL: URL? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.title = title
        self.genre = genre
        self.posterAssetName = posterAssetName
        self.posterURL = posterURL
        self.notes = notes
    }
}

