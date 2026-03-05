import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    // Lists store from environment
    @EnvironmentObject private var listsStore: LocalMovieLists
    @State private var showingAddToList = false

    init(movieID: String) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieID: movieID))
    }

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            Group {
                if isLandscape {
                    MovieDetailLandscapeView(viewModel: viewModel)
                } else {
                    MovieDetailPortraitView(viewModel: viewModel)
                }
            }
            .navigationTitle(viewModel.titleText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Before showing sheet, proactively cache current movie metadata
                        cacheCurrentMovieMetadata()
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
                    Task { @MainActor in
                        viewModel.clearError()
                    }
                }
            }, message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            })
            .sheet(isPresented: $showingAddToList) {
                AddToListSheet(movieID: viewModel.movieID)
                    .environmentObject(listsStore)
            }
        }
    }

    private func cacheCurrentMovieMetadata() {
        let id = viewModel.movieID
        let title = viewModel.titleText
        let genre = viewModel.genresText?.components(separatedBy: " • ").first ?? "My List"
        let posterURL = viewModel.posterURL
        listsStore.updateInsertCachedMovie(id: id, title: title, genre: genre, posterURL: posterURL)
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movieID: "tt0133093")
            .environmentObject(LocalMovieLists())
    }
}
