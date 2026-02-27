import CoreLocation
import SwiftUI

class LocationViewModel: NSObject, ObservableObject {

    // MARK: - Published state
    @Published var selectedAddress: Address?
    @Published var savedAddresses: [Address] = []
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLocating = false
    @Published var locationError: String? = nil

    // MARK: - Private
    private let manager  = CLLocationManager()
    private let geocoder = CLGeocoder()

    private enum UDKey {
        static let selected = "emart_loc_selected"
        static let saved    = "emart_loc_saved"
    }

    // MARK: - Init
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authStatus = manager.authorizationStatus
        load()
    }

    // MARK: - Public API

    /// Requests current GPS location (handles permission flow).
    func requestCurrentLocation() {
        locationError = nil
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isLocating = true
            manager.requestLocation()
        case .denied, .restricted:
            locationError = "Location access denied. Please enable it in Settings → eMart."
        @unknown default:
            break
        }
    }

    /// Sets the active address and persists it.
    func selectAddress(_ address: Address) {
        selectedAddress = address
        persistSelected()
    }

    /// Saves (or updates) an address in the saved list and makes it active.
    func saveAddress(_ address: Address) {
        if let idx = savedAddresses.firstIndex(where: { $0.id == address.id }) {
            savedAddresses[idx] = address
        } else {
            savedAddresses.append(address)
        }
        selectedAddress = address
        persistAll()
    }

    /// Removes saved addresses at the given offsets.
    func deleteAddresses(at offsets: IndexSet) {
        savedAddresses.remove(atOffsets: offsets)
        persistAll()
    }

    // MARK: - Persistence

    private func load() {
        if let data    = UserDefaults.standard.data(forKey: UDKey.saved),
           let decoded = try? JSONDecoder().decode([Address].self, from: data) {
            savedAddresses = decoded
        }
        if let data    = UserDefaults.standard.data(forKey: UDKey.selected),
           let decoded = try? JSONDecoder().decode(Address.self, from: data) {
            selectedAddress = decoded
        }
    }

    private func persistAll() {
        if let data = try? JSONEncoder().encode(savedAddresses) {
            UserDefaults.standard.set(data, forKey: UDKey.saved)
        }
        persistSelected()
    }

    private func persistSelected() {
        if let data = try? JSONEncoder().encode(selectedAddress) {
            UserDefaults.standard.set(data, forKey: UDKey.selected)
        }
    }

    // MARK: - Reverse Geocoding
    private func reverseGeocode(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self, let p = placemarks?.first else {
                DispatchQueue.main.async { self?.isLocating = false }
                return
            }
            let city    = p.locality ?? p.administrativeArea ?? ""
            let area    = p.subLocality ?? p.thoroughfare ?? ""
            let pincode = p.postalCode ?? ""

            let address = Address(
                id: UUID(),
                label: .other,
                city: city,
                area: area,
                pincode: pincode,
                latitude:  location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            DispatchQueue.main.async {
                self.isLocating = false
                self.selectedAddress = address
                self.persistSelected()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        reverseGeocode(loc)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLocating = false
            self.locationError = "Couldn't determine location. Please try again."
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { self.authStatus = manager.authorizationStatus }
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            isLocating = true
            manager.requestLocation()
        }
    }
}
