import SwiftUI

struct PopularTabView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                SkeletonHomeView()
                    .padding(.top, 8)
                    .accessibilityHidden(true)
            } else {
                LazyVStack(alignment: .leading, spacing: 20) {
                    SectionHeader("Most Popular Movies", size: 30)
                        .padding(.horizontal, 16)

                    if viewModel.groupedMovies.count <= 0 {
                        Text("Something went wrong loading the movies... Please try again later.")
                            .padding(.horizontal, 16)
                    }

                    ForEach(viewModel.groupedMovies, id: \.genre) { group in
                        MovieHorizontalScrollView(title: group.genre, movies: group.movies)
                    }
                }
                .padding(.top, 8)
            }
        }
        .navigationTitle("Popular")
        .navigationBarTitleDisplayMode(.inline)
    }
}

