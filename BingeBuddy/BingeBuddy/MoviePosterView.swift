import SwiftUI

struct MoviePosterView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Poster
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .aspectRatio(2/3, contentMode: .fit)
                    .overlay(
                        Group {
                            if let assetName = movie.posterAssetName {
                                Image(assetName)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "film")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(24)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    )
                    .clipped()
                    .cornerRadius(8)
            }

            // Titel
            Text(movie.title)
                .font(.caption)
                .lineLimit(1)
                .foregroundStyle(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(movie.title)
    }
}
