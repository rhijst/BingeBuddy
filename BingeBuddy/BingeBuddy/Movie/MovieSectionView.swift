import SwiftUI

struct MovieSectionView: View {
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
                        if let id = movie.id {
                            NavigationLink(value: id) {
                                MoviePosterView(movie: movie)
                                    .frame(width: 120)
                            }
                            .tint(.primary) // Ensure text inside the link uses normal label color
                        } else {
                            // Fallback: no ID, show non-interactive poster
                            MoviePosterView(movie: movie)
                                .frame(width: 120)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
