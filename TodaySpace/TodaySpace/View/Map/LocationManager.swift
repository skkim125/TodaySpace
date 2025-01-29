//
//  LocationManager.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager =  CLLocationManager()
    @Published var myLocation: Bool = false

    override init() {
        super.init()
        locationManager.delegate =  self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        checkLocationAuthorization()
    }
    // 위치 권한 확인 및 위치 업데이트 시작
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print ("위치 미설정 상태")
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print ("위치 제한 상태")
            
        case .denied:
            print ("위치 거부 상태")
            
        case .authorizedAlways, .authorizedWhenInUse:
            print ("위치 허용 상태")
            locationManager.requestLocation()

            if let _ = locationManager.location {
                myLocation = true
            }
            
        @unknown default :
            print ("위치 서비스 비활성화됨")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        let coordinate = newLocation.coordinate
        print(coordinate)
    }
    
    func locationUpdate() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 받아오는 데 실패함")
    }
}
