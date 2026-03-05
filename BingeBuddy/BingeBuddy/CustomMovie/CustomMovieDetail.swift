import SwiftUI

struct CustomMovieDetail: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster (mirrors portrait detail view behavior)
                if let url = movie.posterURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(2/3, contentMode: .fit)
                                ProgressView()
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(maxWidth: .infinity)
                                .aspectRatio(2/3, contentMode: .fit)
                                .overlay(
                                    Image(systemName: "film")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(24)
                                        .foregroundStyle(.secondary)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else if let assetName = movie.posterAssetName, !assetName.isEmpty {
                    // Local asset fallback if provided
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                } else {
                    // Placeholder when there is no poster
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(maxWidth: .infinity)
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay(
                            Image(systemName: "film")
                                .resizable()
                                .scaledToFit()
                                .padding(24)
                                .foregroundStyle(.secondary)
                        )
                }

                // Title
                Text(movie.title)
                    .font(.title2.weight(.semibold))
                    .accessibilityAddTraits(.isHeader)

                // Genres
                if !movie.genre.isEmpty {
                    Text(movie.genre)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Plot
                if let plot = movie.plot, !plot.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Plot")
                            .font(.headline)
                        Text(plot)
                            .font(.body)
                    }
                }

                // Credits
                if let directors = movie.directors, !directors.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Director(s)")
                            .font(.headline)
                        Text(directors.joined(separator: ", "))
                            .font(.body)
                    }
                }

                if let writers = movie.writers, !writers.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Writer(s)")
                            .font(.headline)
                        Text(writers.joined(separator: ", "))
                            .font(.body)
                    }
                }

                if let actors = movie.actors, !actors.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Actor(s)")
                            .font(.headline)
                        Text(actors.joined(separator: ", "))
                            .font(.body)
                    }
                }

                // Notes
                if let notes = movie.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Custom Movie")
        .navigationBarTitleDisplayMode(.inline)
    }
}
