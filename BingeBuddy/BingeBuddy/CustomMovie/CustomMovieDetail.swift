import SwiftUI

struct CustomMovieDetailView: View {
    let movie: Movie

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
        }
    }
}
