//
//  KonumViewModel.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 18.06.2026.
//

import Foundation
import CoreLocation


class KonumViewModel: NSObject {
    static let shared = KonumViewModel()

    private let locationManager = CLLocationManager()
    private(set) var sonKonum: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 10

        locationManager.startUpdatingLocation()
    }
}
extension KonumViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        sonKonum = locations.last
    }
}
