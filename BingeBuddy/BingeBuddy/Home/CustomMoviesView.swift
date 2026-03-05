import SwiftUI

struct CustomMoviesView: View {
    @EnvironmentObject private var store: CustomMoviesStore
    @State private var showingAdd = false
    @State private var searchText: String = ""
    @State private var sortAscending: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Custom Movies")
                    .font(.system(size: 30, weight: .semibold))
                Spacer()
                Button {
                    showingAdd = true
                } label: {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .accessibilityLabel("Add custom movie")
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            // Search + Sort
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search title or genre", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button {
                    sortAscending.toggle()
                } label: {
                    Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                }
                .accessibilityLabel("Toggle sort order")
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // List
            List {
                ForEach(filteredAndSorted) { movie in
                    NavigationLink {
                        CustomMovieDetail(movie: movie)
                    } label: {
                        CustomMovieRow(movie: movie)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            store.delete(movie)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            presentEdit(movie)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                    .contextMenu {
                        Button {
                            presentEdit(movie)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            store.delete(movie)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: store.delete)
                .onMove(perform: store.move)
            }
            .listStyle(.insetGrouped)
        }
        .sheet(isPresented: $showingAdd) {
            CustomMovieFormView { newMovie in
                store.create(
                    title: newMovie.title,
                    genre: newMovie.genre,
                    notes: newMovie.notes,
                    posterURLString: newMovie.posterURLString
                )
            }
        }
    }

    private var filteredAndSorted: [CustomMovie] {
        let base = store.movies.filter { movie in
            guard !searchText.isEmpty else { return true }
            let needle = searchText.lowercased()
            return movie.title.lowercased().contains(needle)
                || (movie.genre?.lowercased().contains(needle) ?? false)
                || (movie.notes?.lowercased().contains(needle) ?? false)
        }
        return base.sorted { a, b in
            if sortAscending {
                return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedAscending
            } else {
                return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedDescending
            }
        }
    }

    private func presentEdit(_ movie: CustomMovie) {
        // Present a single-use sheet for editing
        // Use an ephemeral binding via a separate window
        let item = movie
        let controller = UIHostingController(rootView:
            CustomMovieFormView(movie: item) { edited in
                store.update(edited)
            }
        )
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.keyWindow {
            window.rootViewController?.present(controller, animated: true)
        }
    }
}

// Helpers

private struct CustomMovieRow: View {
    let movie: CustomMovie

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 60)
                    .aspectRatio(2/3, contentMode: .fit)
                    .overlay(
                        Group {
                            if let url = movie.posterURL {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let img):
                                        img.resizable().scaledToFill()
                                    case .failure:
                                        Image(systemName: "film")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                            .foregroundStyle(.secondary)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "film")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    )
                    .clipped()
                    .cornerRadius(6)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                if let genre = movie.genre, !genre.isEmpty {
                    Text(genre)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

private struct CustomMovieDetail: View {
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

private extension UIWindowScene {
    var keyWindow: UIWindow? {
        return self.windows.first { $0.isKeyWindow }
    }
}
