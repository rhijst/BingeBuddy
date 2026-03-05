struct CachedMovie: Codable, Hashable {
    let id: String
    let title: String
    let genre: String
    let posterURLString: String?
}
