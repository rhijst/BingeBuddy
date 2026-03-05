import SwiftUI

struct CustomMovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 150)
                    .aspectRatio(2/3, contentMode: .fit)
                    .overlay(
                        Group {
                            if let assetName = movie.posterAssetName {
                                Image(assetName)
                                    .resizable()
                                    .scaledToFill()
                            } else if let url = movie.posterURL {
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
                if (!movie.genre.isEmpty) {
                    Text(movie.genre)
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
            movie: Movie(
                id: "custom-\(UUID().uuidString)",
                title: "My Custom Matrix",
                genre: "Sci-Fi",
                posterAssetName: nil,
                posterURL: URL(string: "https://m.media-amazon.com/images/I/71x7df0yZdL._AC_SY300_SX300_QL70_ML2_.jpg"),
                notes: "Rewatch soon."
            )
        )
        CustomMovieRow(
            movie: Movie(
                id: "custom-\(UUID().uuidString)",
                title: "Untitled Project",
                genre: "",
                posterAssetName: nil,
                posterURL: nil,
                notes: nil
            )
        )
    }
    .listStyle(.insetGrouped)
}

