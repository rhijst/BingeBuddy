import SwiftUI

struct PersonFilmographyView: View {
    @StateObject private var viewModel: PersonFilmographyViewModel

    init(personID: String, personName: String? = nil) {
        _viewModel = StateObject(wrappedValue: PersonFilmographyViewModel(personID: personID, personName: personName))
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    SkeletonHomeView()
                        .accessibilityHidden(true)
                } else if viewModel.movies.isEmpty {
                    Text("No credits found.")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                } else {
                    // Group by genre similar to HomeView for a familiar layout
                    let groups = Dictionary(grouping: viewModel.movies, by: { $0.genre })
                    let orderedGenres = groups.keys.sorted()
                    ForEach(orderedGenres, id: \.self) { genre in
                        if let movies = groups[genre] {
                            // Inline the section to control navigation links here
                            VStack(alignment: .leading, spacing: 12) {
                                Text(genre)
                                    .font(.headline)
                                    .padding(.horizontal, 16)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(alignment: .top, spacing: 12) {
                                        ForEach(movies) { movie in
                                            NavigationLink {
                                                MovieDetailView(movieID: movie.id ?? "")
                                            } label: {
                                                MoviePosterView(movie: movie)
                                                    .frame(width: 120) // match your poster width
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
        .navigationTitle(viewModel.navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        })
    }
}

#Preview {
    NavigationStack {
        PersonFilmographyView(personID: "nm0000206", personName: "Keanu Reeves")
    }
}
