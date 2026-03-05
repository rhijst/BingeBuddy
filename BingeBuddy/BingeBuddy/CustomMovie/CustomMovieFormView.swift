import SwiftUI

struct CustomMovieFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var genre: String
    @State private var notes: String
    @State private var posterURLString: String

    let onSave: (Movie) -> Void
    private var editingMovie: Movie?

    private let allGenres: [String] = [
        "Action",
        "Adventure",
        "Animation",
        "Biography",
        "Comedy",
        "Crime",
        "Documentary",
        "Drama",
        "Family",
        "Fantasy",
        "Film-Noir",
        "Game-Show",
        "History",
        "Horror",
        "Music",
        "Musical",
        "Mystery",
        "News",
        "Reality-TV",
        "Romance",
        "Sci-Fi",
        "Short",
        "Sport",
        "Talk-Show",
        "Thriller",
        "War",
        "Western"
    ]

    init(
        movie: Movie? = nil,
        onSave: @escaping (Movie) -> Void
    ) {
        self.onSave = onSave
        self._title = State(initialValue: movie?.title ?? "")
        self._genre = State(initialValue: movie?.genre ?? "")
        self._notes = State(initialValue: movie?.notes ?? "")
        self._posterURLString = State(initialValue: movie?.posterURL?.absoluteString ?? "")
        self.editingMovie = movie
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)

                    // Genre drop-down (single selection)
                    Picker("Genre (optional)", selection: $genre) {
                        Text("None").tag("")
                        ForEach(allGenres, id: \.self) { g in
                            Text(g).tag(g)
                        }
                    }

                    TextField("Poster URL (optional)", text: $posterURLString)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle(editingMovie == nil ? "New Custom Movie" : "Edit Custom Movie")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        let newURL = posterURLString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : URL(string: posterURLString)

                        let model = Movie(
                            id: editingMovie?.id ?? "custom-\(UUID().uuidString)",
                            title: trimmedTitle,
                            genre: genre, // empty string allowed for "None"
                            posterAssetName: nil,
                            posterURL: newURL,
                            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes
                        )
                        onSave(model)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

