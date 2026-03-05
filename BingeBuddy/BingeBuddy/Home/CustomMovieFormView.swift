import SwiftUI

struct CustomMovieFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var genre: String
    @State private var notes: String
    @State private var posterURLString: String

    let onSave: (CustomMovie) -> Void
    private var editingMovie: CustomMovie?

    init(
        movie: CustomMovie? = nil,
        onSave: @escaping (CustomMovie) -> Void
    ) {
        self.onSave = onSave
        self._title = State(initialValue: movie?.title ?? "")
        self._genre = State(initialValue: movie?.genre ?? "")
        self._notes = State(initialValue: movie?.notes ?? "")
        self._posterURLString = State(initialValue: movie?.posterURLString ?? "")
        self.editingMovie = movie
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Genre (optional)", text: $genre)
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
                        var model = CustomMovie(
                            id: editingMovie?.id ?? UUID(),
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            genre: genre.nilIfBlank,
                            notes: notes.nilIfBlank,
                            posterURLString: posterURLString.nilIfBlank
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

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
