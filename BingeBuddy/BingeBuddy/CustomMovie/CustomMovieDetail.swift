import SwiftUI

struct CustomMovieDetailView: View {
    let movie: Movie

    @EnvironmentObject private var listsStore: LocalMovieLists
    @State private var showingAddToList = false

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            Group {
                if isLandscape {
                    CustomMovieDetailLandscapeView(movie: movie)
                } else {
                    CustomMovieDetailPortraitView(movie: movie)
                }
            }
            .navigationTitle("Custom Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        listsStore.updateInsertCachedMovie(
                            id: movie.id,
                            title: movie.title,
                            genre: movie.genre.isEmpty ? "My List" : movie.genre,
                            posterURL: movie.posterURL
                        )
                        showingAddToList = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add to list")
                }
            }
            .sheet(isPresented: $showingAddToList) {
                AddToListSheet(movieID: movie.id)
                    .environmentObject(listsStore)
            }
        }
    }
}
