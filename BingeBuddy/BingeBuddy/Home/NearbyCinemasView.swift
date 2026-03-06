import SwiftUI
import MapKit
import CoreLocation

@MainActor
struct NearbyCinemasView: View {

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Nearby Cinemas")
                    .font(.system(size: 30, weight: .semibold))
                Spacer()
                Button {
//                    Task { await searchCinemas() }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            // Map
            Map() {
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NearbyCinemasView()
}
