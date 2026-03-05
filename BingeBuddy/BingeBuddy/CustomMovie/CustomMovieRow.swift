import SwiftUI

struct CustomMovieRow: View {
    let movie: Movie

    // Consistent thumbnail size (2:3 aspect)
    private let thumbWidth: CGFloat = 100
    private var thumbHeight: CGFloat { thumbWidth * 1.5 }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                // Background placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.15))

                // Image content (asset or URL) with consistent rendering
                Group {
                    if let assetName = movie.posterAssetName, !assetName.isEmpty {
                        Image(assetName)
                            .resizable()
                            .scaledToFill()
                    } else if let url = movie.posterURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let img):
                                img
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "film")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(24)
                                    .foregroundStyle(.secondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "film")
                            .resizable()
                            .scaledToFit()
                            .padding(24)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(width: thumbWidth, height: thumbHeight)
            .clipped()
            .cornerRadius(6)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                if !movie.genre.isEmpty {
                    Text(movie.genre)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
