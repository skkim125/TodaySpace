//
//  LocationManager.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var isInitialized: Bool = false
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func startLocationServices() {
        locationManager.delegate = self
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("위치 미설정 상태")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("위치 제한 상태")
        case .denied:
            print("위치 거부 상태")
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치 서비스 활성화")
            locationManager.requestLocation()
        @unknown default:
            print("위치 서비스 비활성화됨")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print("Authorization status changed: \(status)")
        
        // 권한이 허용되었을 때 즉시 위치 요청
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location updated: \(location.coordinate)")
        DispatchQueue.main.async {
            self.currentLocation = location
            self.isInitialized = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 받아오는 데 실패함: \(error)")
    }
}
