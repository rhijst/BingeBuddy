struct TitlesResponse: Decodable {
    let titles: [TitleDTO]?
}

struct TitleDTO: Decodable {
    let id: String?
    let type: String?
    let primaryTitle: String?
    let originalTitle: String?
    let primaryImage: PrimaryImageDTO?
    let startYear: Int?
    let endYear: Int?
    let runtimeSeconds: Int?
    let genres: [String]?
    let rating: RatingDTO?
    let plot: String?
}

struct PrimaryImageDTO: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
}

struct RatingDTO: Decodable {
    let aggregateRating: Double?
    let voteCount: Int?
}
