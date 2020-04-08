//
//  SWLocationManager.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

enum SWLocationManagerEvent {
    case getLocation
    case currentLocation(_ location: CLLocation)
    case getLocationError(_ error: Error)
}

protocol SWLocationManagerType {
    var uiEvents: PublishSubject<SWLocationManagerEvent> { get }
    var managerEvents: PublishSubject<SWLocationManagerEvent> { get }
}

final class SWLocationManager: NSObject, SWLocationManagerType {
    static let shared = SWLocationManager()

    let uiEvents = PublishSubject<SWLocationManagerEvent>()
    let managerEvents = PublishSubject<SWLocationManagerEvent>()

    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        setupEvents()
    }
}

// MARK: - Private methods
extension SWLocationManager {
    private func setupEvents() {
        managerEvents
            .asObserver()
            .subscribe(onNext: { [weak self] event in
                guard let `self` = self else { return }
                switch event {
                case .getLocation:
                    self.getCurrentLocation()
                default: break
                }
            }).disposed(by: disposeBag)
    }

    private func getCurrentLocation() {
        if #available(iOS 9.0, *) {
            self.locationManager.requestLocation()
        }
        self.locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension SWLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        uiEvents.onNext(.currentLocation(location))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        uiEvents.onNext(.getLocationError(error))
    }
}
