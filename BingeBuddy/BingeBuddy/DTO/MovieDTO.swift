private struct TitlesResponse: Decodable {
    let titles: [TitleDTO]?
}

private struct TitleDTO: Decodable {
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

private struct PrimaryImageDTO: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
}

private struct RatingDTO: Decodable {
    let aggregateRating: Double?
    let voteCount: Int?
}
