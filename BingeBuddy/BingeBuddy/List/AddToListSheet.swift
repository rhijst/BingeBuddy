import SwiftUI

struct AddToListSheet: View {
    @ObservedObject var store: MovieListsStore
    let movieID: String
    @State private var newListName: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Create new list
                HStack {
                    TextField("New list name", text: $newListName)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        let name = newListName
                        newListName = ""
                        store.createList(named: name)
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                    .disabled(newListName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)

                // Lists
                List {
                    ForEach(store.lists) { list in
                        Button {
                            store.toggle(movieID: movieID, in: list.id)
                        } label: {
                            HStack {
                                Text(list.name)
                                Spacer()
                                if store.contains(movieID: movieID, in: list.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.tint)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: store.deleteLists)
                }
            }
            .navigationTitle("Add to List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
