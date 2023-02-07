//
//  Location Manager.swift
//  WeatherTV
//
//  Created by Сергей on 01.04.2021.
//
import Foundation
import Combine
import CoreLocation
//import MapKit


class LocationManager: NSObject {
    
    var location: CLLocation?
    
    var status: CLAuthorizationStatus?
    
    var placemark: CLPlacemark?
    
    static let shared = LocationManager()
    private let manager = CLLocationManager()

    
    override private init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location

    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find location: \(error.localizedDescription)")
    }
}
