import SwiftUI

struct MoviePosterView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Poster
            ZStack {
                // Placeholder achtergrond
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
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
                                            .progressViewStyle(.circular)
                                            .tint(.secondary)
                                            .scaleEffect(0.8)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        Image(systemName: "film")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(24)
                                            .foregroundStyle(.secondary)
                                    @unknown default:
                                        Image(systemName: "film")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(24)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            } else {
                                // Als er geen lokale asset is, kan hier later een AsyncImage met URL komen
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
