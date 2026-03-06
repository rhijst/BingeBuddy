import SwiftUI

struct SearchTabView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                // Header
                SectionHeader("Search", size: 30)
                    .padding(.horizontal, 16)

                // Inline Search Bar
                HStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search title", text: $viewModel.searchText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .onChange(of: viewModel.searchText) { _, newValue in
                    let query = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    Task {
                        if query.isEmpty {
                            viewModel.clearSearch()
                        } else {
                            try? await Task.sleep(nanoseconds: 400_000_000) // debounce ~0.4s
                            guard query == viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                            await viewModel.performSearch()
                        }
                    }
                }

                // Content states
                if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Search for any movie title.")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                } else if viewModel.isSearching {
                    ProgressView()
                        .padding(.top, 24)
                } else if let error = viewModel.searchError {
                    Text(error)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                } else if viewModel.searchResults.isEmpty {
                    Text("No results")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                } else {
                    MovieHorizontalScrollView(title: "Results", movies: viewModel.searchResults)
                }
            }
            .padding(.top, 8)
        }
    }
}

