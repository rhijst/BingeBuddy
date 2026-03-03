import Foundation

struct Movie: Identifiable, Hashable {
    let id: String
    let title: String
    let genre: String

    //PosterAssetName: if there is no online poster, use cached variant (local use)
    let posterAssetName: String?
    let posterURL: URL?

    init(
        id: String,
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
