//
//  Location.swift
//  WeatherApp
//
//  Created by MacBook Air on 11.12.24.
//

import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private var successCompletion: ((CLLocation) -> Void)?
    private var failureCompletion: ((CLLocation) -> Void)?
    
    
    // 55.184217, 30.202878
    // CLLocation(latitude: 51.50853, longitude: -0.12853)
    private let standartLocation = CLLocation(latitude: 55.184217, longitude: 30.202878)
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func getUserLocation(successCompletion: @escaping ((CLLocation) -> Void), failureCompletion: @escaping ((CLLocation) -> Void)) {
        self.successCompletion = successCompletion
        self.failureCompletion = failureCompletion
        self.checkAuthorizationStatus()
    }
  
}

// MARK: - CLLocationManagerDelegate -

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        successCompletion?(location)
        manager.stopUpdatingLocation() // Stop updating location after successful result
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            failureCompletion?(standartLocation)
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
}
