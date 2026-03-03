import Foundation

struct MovieDetail {
    let id: String
    let title: String
    let posterURL: URL?
    let year: Int?
    let runtimeMinutes: Int?
    let genres: [String]
    let rating: Double?
    let plot: String?
    let directors: [String]
    let writers: [String]
}
