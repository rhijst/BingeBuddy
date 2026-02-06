import Foundation

struct Movie: Identifiable, Hashable {
    let id: UUID
    let title: String
    let genre: String

    // Voor nu lokale assetnaam, later kan posterURL gebruikt worden
    let posterAssetName: String?
    let posterURL: URL?

    init(
        id: UUID = UUID(),
        title: String,
        genre: String,
        posterAssetName: String? = nil,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.genre = genre
        self.posterAssetName = posterAssetName
        self.posterURL = posterURL
    }
}
