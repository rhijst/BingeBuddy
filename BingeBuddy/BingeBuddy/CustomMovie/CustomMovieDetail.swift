import SwiftUI

struct CustomMovieDetail: View {
    let movie: CustomMovie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.15))
                                    .aspectRatio(2/3, contentMode: .fit)
                                ProgressView()
                            }
                        case .success(let img):
                            img.resizable().scaledToFit().cornerRadius(10)
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
                }

                Text(movie.title)
                    .font(.title2.weight(.semibold))

                if let genre = movie.genre, !genre.isEmpty {
                    Text(genre)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

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
