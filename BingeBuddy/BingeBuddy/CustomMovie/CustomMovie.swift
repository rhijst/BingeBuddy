import Foundation

struct CustomMovie: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var genre: String?
    var notes: String?
    var posterURLString: String?

    var posterURL: URL? {
        posterURLString.flatMap(URL.init(string:))
    }
}
