import SwiftUI

struct CustomMovieRow: View {
    let movie: CustomMovie

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 150)
                    .aspectRatio(2/3, contentMode: .fit)
                    .overlay(
                        Group {
                            if let url = movie.posterURL {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let img):
                                        img.resizable()
                                    case .failure:
                                        Image(systemName: "film")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "film")
                            }
                        }
                    )
                    .clipped()
                    .cornerRadius(6)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                if let genre = movie.genre, !genre.isEmpty {
                    Text(genre)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    List {
        CustomMovieRow(
            movie: CustomMovie(
                id: UUID(),
                title: "My Custom Matrix",
                genre: "Sci-Fi",
                notes: "Rewatch soon.",
                posterURLString: "https://m.media-amazon.com/images/I/71x7df0yZdL._AC_SY300_SX300_QL70_ML2_.jpg"
                
            )
        )
        CustomMovieRow(
            movie: CustomMovie(
                id: UUID(),
                title: "Untitled Project",
                genre: nil,
                notes: nil,
                posterURLString: nil
            )
        )
    }
    .listStyle(.insetGrouped)
}
