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
            .padding(.bottom, 12)

            // List
            List {
                ForEach(filteredAndSorted) { movie in
                    NavigationLink {
                        CustomMovieDetailView(movie: movie)
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
                    posterURLString: newMovie.posterURL?.absoluteString,
                    plot: newMovie.plot,
                    directorsCSV: newMovie.directors?.joined(separator: ", "),
                    writersCSV: newMovie.writers?.joined(separator: ", "),
                    actorsCSV: newMovie.actors?.joined(separator: ", ")
                )
            }
        }

    }

    private var filteredAndSorted: [Movie] {
        let base = store.movies.filter { movie in
            guard !searchText.isEmpty else { return true }
            let needle = searchText.lowercased()
            return movie.title.lowercased().contains(needle)
                || movie.genre.lowercased().contains(needle)
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

    private func presentEdit(_ movie: Movie) {
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

private extension UIWindowScene {
    var keyWindow: UIWindow? {
        return self.windows.first { $0.isKeyWindow }
    }
}
