import Foundation

// GET https://api.imdbapi.dev/names/{id}/filmography
struct NamesFilmographyResponse: Decodable {
    let credits: [NameCreditDTO]?
}

struct NameCreditDTO: Decodable, Identifiable {
    // Use title id as a stable identity for list diffing
    var id: String { title.id ?? UUID().uuidString }
    let title: CreditTitleDTO
}

struct CreditTitleDTO: Decodable {
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
