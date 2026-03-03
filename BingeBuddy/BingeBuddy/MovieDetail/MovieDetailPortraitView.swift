import SwiftUI

struct MovieDetailPortraitView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster
                if let url = viewModel.posterURL {
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
                }

                // Title
                Text(viewModel.titleText)
                    .font(.title2.weight(.semibold))
                    .accessibilityAddTraits(.isHeader)

                // Meta row: year • runtime • rating
                HStack(spacing: 12) {
                    if let year = viewModel.yearText {
                        Label(year, systemImage: "calendar")
                    }
                    if let runtime = viewModel.runtimeText {
                        Label(runtime, systemImage: "clock")
                    }
                    if let rating = viewModel.ratingText {
                        Label {
                            Text(rating)
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                // Genres
                if let genres = viewModel.genresText {
                    Text(genres)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Plot
                if let plot = viewModel.plotText, !plot.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Plot")
                            .font(.headline)
                        Text(plot)
                            .font(.body)
                    }
                }

                // Credits
                if let directors = viewModel.directorsText {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Director(s)")
                            .font(.headline)
                        Text(directors)
                            .font(.body)
                    }
                }

                if let writers = viewModel.writersText {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Writer(s)")
                            .font(.headline)
                        Text(writers)
                            .font(.body)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    MovieDetailPortraitView(viewModel: MovieDetailViewModel(movieID: "tt0133093"))
}
