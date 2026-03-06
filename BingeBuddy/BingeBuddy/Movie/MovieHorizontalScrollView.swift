import SwiftUI

struct MovieHorizontalScrollView: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(title)
                .font(.title3.weight(.semibold))
                .padding(.horizontal, 16)

            // Posters
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie) {
                            MoviePosterView(movie: movie)
                                .frame(width: 120)
                        }
                        .tint(.primary)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    MovieHorizontalScrollView(
        title: "Popular",
        movies: [
            Movie(
                id: "tt0133093",
                title: "The Matrix",
                genre: "Sci-Fi",
                posterAssetName: nil,
                posterURL: URL(string: "https://m.media-amazon.com/images/M/MV5BMm.jpg")
            ),
            Movie(
                id: "tt0111161",
                title: "Shawshank",
                genre: "Drama",
                posterAssetName: nil,
                posterURL: URL(string: "https://m.media-amazon.com/images/M/MV5B.jpg")
            ),
            Movie(
                id: "custom-\(UUID().uuidString)",
                title: "My Custom Film",
                genre: "Sci-Fi",
                posterAssetName: nil,
                posterURL: nil
            )
        ]
    )
}
