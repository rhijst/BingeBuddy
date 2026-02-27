import Foundation

// Decodable DTOs for GET https://api.imdbapi.dev/titles/{id}
struct DetailedTitleDTO: Decodable {
    let id: String?
    let type: String?
    let isAdult: Bool?
    let primaryTitle: String?
    let originalTitle: String?
    let primaryImage: DetailedImageDTO?
    let startYear: Int?
    let endYear: Int?
    let runtimeSeconds: Int?
    let genres: [String]?
    let rating: DetailedRatingDTO?
    let metacritic: MetacriticDTO?
    let plot: String?
    let directors: [DetailedPersonDTO]?
    let writers: [DetailedPersonDTO]?
    let stars: [DetailedPersonDTO]?
    let originCountries: [DetailedCodeNameDTO]?
    let spokenLanguages: [DetailedCodeNameDTO]?
    let interests: [DetailedInterestDTO]?
}

struct DetailedImageDTO: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
    let type: String?
}

struct DetailedRatingDTO: Decodable {
    let aggregateRating: Double?
    let voteCount: Int?
}

struct MetacriticDTO: Decodable {
    let url: String?
    let score: Int?
    let reviewCount: Int?
}

struct DetailedPersonDTO: Decodable {
    let id: String?
    let displayName: String?
    let alternativeNames: [String]?
    let primaryImage: DetailedImageDTO?
    let primaryProfessions: [String]?
    let biography: String?
    let heightCm: Int?
    let birthName: String?
    let birthDate: DetailedDateDTO?
    let birthLocation: String?
    let deathDate: DetailedDateDTO?
    let deathLocation: String?
    let deathReason: String?
    let meterRanking: DetailedMeterRankingDTO?
}

struct DetailedDateDTO: Decodable {
    let year: Int?
    let month: Int?
    let day: Int?
}

struct DetailedMeterRankingDTO: Decodable {
    let currentRank: Int?
    let changeDirection: String?
    let difference: Int?
}

struct DetailedCodeNameDTO: Decodable {
    let code: String?
    let name: String?
}

struct DetailedInterestDTO: Decodable {
    let id: String?
    let name: String?
    let primaryImage: DetailedImageDTO?
    let description: String?
    let isSubgenre: Bool?
    // similarInterests omitted (heterogeneous/unknown shape in sample)
}
