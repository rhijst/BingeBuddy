import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    // Lists store and sheet state
    @StateObject private var listsStore = MovieListsStore()
    @State private var showingAddToList = false

    init(movieID: String) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieID: movieID))
    }

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            Group {
                if isLandscape {
                    // Tweekoloms lay-out in landscape
                    HStack(alignment: .top, spacing: 16) {
                        // Linker kolom: poster
                        VStack {
                            if let url = viewModel.posterURL {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.15))
                                                .aspectRatio(2/3, contentMode: .fit)
                                            ProgressView()
                                        }
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                            .accessibilityHidden(true)
                                    case .failure:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.15))
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
                            } else {
                                // Placeholder wanneer er geen posterURL is
                                Rectangle()
                                    .fill(Color.gray.opacity(0.15))
                                    .aspectRatio(2/3, contentMode: .fit)
                                    .overlay(
                                        Image(systemName: "film")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(24)
                                            .foregroundStyle(.secondary)
                                    )
                            }
                        }
                        // Geef de poster ~40% van de breedte; pas aan naar wens (bijv. 0.35–0.45).
                        .frame(width: geo.size.width * 0.4, alignment: .top)
                        .padding(.leading, 16)

                        // Rechter kolom: details (scrollbaar indien nodig)
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
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
                            .padding(.trailing, 16)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } else {
                    // Bestaande portrait lay-out
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
            .navigationTitle(viewModel.titleText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddToList = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add to list")
                }
            }
            .task {
                await viewModel.load()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView().scaleEffect(1.2)
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK", role: .cancel) {
                    // clear error
                    Task { @MainActor in
                        viewModel.clearError()
                    }
                }
            }, message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            })
            .sheet(isPresented: $showingAddToList) {
                AddToListSheet(store: listsStore, movieID: viewModel.movieID)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movieID: "tt0133093")
    }
}
