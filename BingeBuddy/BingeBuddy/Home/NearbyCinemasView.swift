import SwiftUI
import MapKit
import CoreLocation
import Combine

// MARK: - Async Location Manager

@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // Request permission asynchronously
    func requestLocationPermission() async -> CLAuthorizationStatus {
        // If we already have a determined status, return it immediately.
        let current = manager.authorizationStatus
        if current != .notDetermined {
            return current
        }

        return await withCheckedContinuation { continuation in
            self.permissionContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }

    func requestCurrentLocation() async throws -> CLLocation {
        try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            manager.requestLocation()
        }
    }

    // MARK: - Continuations
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }

        if let cont = permissionContinuation {
            cont.resume(returning: manager.authorizationStatus)
            permissionContinuation = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        userLocation = loc
        locationContinuation?.resume(returning: loc)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}

// MARK: - Main View

struct NearbyCinemasView: View {

    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .userLocation(
        followsHeading: false,
        fallback: .automatic
    )

    @State private var isRequestingLocation = false

    var body: some View {
        VStack(spacing: 0) {
            header
            mapView
        }
        .ignoresSafeArea()
        .task {
            // Async request for permission and initial location
            isRequestingLocation = true
            let status = await locationManager.requestLocationPermission()
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                do {
                    let location = try await locationManager.requestCurrentLocation()
                    withAnimation {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    }
                } catch {
                    print("Failed to get location:", error)
                }
            }
            isRequestingLocation = false
        }
    }
}

// MARK: - UI Components

extension NearbyCinemasView {

    private var header: some View {
        HStack {
            Text("Nearby Cinemas")
                .font(.system(size: 30, weight: .semibold))
            Spacer()
            Button {
                withAnimation {
                    cameraPosition = .userLocation(
                        followsHeading: false,
                        fallback: .automatic
                    )
                }
            } label: {
                Label("Recenter", systemImage: "location.fill")
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private var mapView: some View {
        Map(position: $cameraPosition) {
            // Blue user location dot
            UserAnnotation()
            // Future cinema annotations go here
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    }
}

// MARK: - Preview

#Preview {
    NearbyCinemasView()
}
