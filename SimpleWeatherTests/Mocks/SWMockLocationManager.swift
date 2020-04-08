//
//  SWMockLocationManager.swift
//  SimpleWeatherTests
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: NSObjectProtocol {
    func locationManager(_ manager: SWMockLocationManager, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: SWMockLocationManager, didFailWithError error: Error)
}

protocol LocationManager {
    // CLLocationManager Properties
    var location: CLLocation { get }
    var delegate: LocationManagerDelegate? { get set }

    // CLLocationManager Methods
    func requestWhenInUseAuthorization()

    // Wrappers for CLLocationManager class functions.
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func isLocationServicesEnabled() -> Bool
}

class SWMockLocationManager: LocationManager {
    var location = CLLocation(
        latitude: 37.3317,
        longitude: -122.0325086
    )

    weak var delegate: LocationManagerDelegate?

    func requestWhenInUseAuthorization() {
        delegate?.locationManager(self, didUpdateLocations: [location])
    }

    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return .authorizedWhenInUse
    }

    func isLocationServicesEnabled() -> Bool {
        return true
    }
}
