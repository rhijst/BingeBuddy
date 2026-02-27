import SwiftUI

struct SkeletonHomeView: View {
    // Show 3–4 sections with a few placeholder cards each
    private let sectionCount = 4
    private let itemsPerRow = 6

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(0..<sectionCount, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 12) {
                    // Fake section title
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 18)
                        .padding(.horizontal, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(0..<itemsPerRow, id: \.self) { _ in
                                SkeletonPosterCard()
                                    .frame(width: 120)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .redacted(reason: .placeholder)
    }
}

struct SkeletonPosterCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(2/3, contentMode: .fit)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 12)
                .padding(.trailing, 24)
        }
    }
}
