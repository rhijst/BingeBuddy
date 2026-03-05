import SwiftUI

struct CustomMovieFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var genre: String
    @State private var notes: String
    @State private var posterURLString: String

    // New fields
    @State private var plot: String
    @State private var directorsCSV: String
    @State private var writersCSV: String
    @State private var actorsCSV: String

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

        // New fields init
        self._plot = State(initialValue: movie?.plot ?? "")
        self._directorsCSV = State(initialValue: (movie?.directors ?? []).joined(separator: ", "))
        self._writersCSV = State(initialValue: (movie?.writers ?? []).joined(separator: ", "))
        self._actorsCSV = State(initialValue: (movie?.actors ?? []).joined(separator: ", "))

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

                Section("Plot") {
                    TextEditor(text: $plot)
                        .frame(minHeight: 120)
                }

                Section("Credits (comma-separated)") {
                    TextField("Directors", text: $directorsCSV)
                        .textInputAutocapitalization(.words)
                    TextField("Writers", text: $writersCSV)
                        .textInputAutocapitalization(.words)
                    TextField("Actors", text: $actorsCSV)
                        .textInputAutocapitalization(.words)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
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

                        let directors = directorsCSV
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }

                        let writers = writersCSV
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }

                        let actors = actorsCSV
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }

                        let model = Movie(
                            id: editingMovie?.id ?? "custom-\(UUID().uuidString)",
                            title: trimmedTitle,
                            genre: genre, // empty string allowed for "None"
                            posterAssetName: nil,
                            posterURL: newURL,
                            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes,
                            plot: plot.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : plot,
                            directors: directors.isEmpty ? nil : directors,
                            writers: writers.isEmpty ? nil : writers,
                            actors: actors.isEmpty ? nil : actors
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
