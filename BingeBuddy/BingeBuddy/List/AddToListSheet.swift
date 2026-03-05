import SwiftUI

struct AddToListSheet: View {
    @EnvironmentObject var localLists: LocalMovieLists
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
                        localLists.createList(named: name)
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                    .disabled(newListName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)

                // Lists
                List {
                    ForEach(localLists.lists) { list in
                        Button {
                            localLists.toggle(movieID: movieID, in: list.id)
                        } label: {
                            HStack {
                                Text(list.name)
                                Spacer()
                                if localLists.contains(movieID: movieID, in: list.id) {
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
                    .onDelete(perform: localLists.deleteLists)
                }
            }
            .navigationTitle("Add to List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
