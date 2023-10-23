import UIKit
import CoreLocation
import NMapsMap

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(lat: Double, lng: Double)
    func didFailWithError(error: Error)
}

class LocationService: NSObject, NMFLocationManagerDelegate, CLLocationManagerDelegate {
    private var locationManager: NMFLocationManager
    weak var delegate: LocationServiceDelegate?

    
    override init() {
        locationManager = NMFLocationManager()
        super.init()
        locationManager.add(self)
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation() -> NMGLatLng? {
        return locationManager.currentLatLng()
    }

    
    // NMFLocationManagerDelegate
    func locationManager(_ locationManager: NMFLocationManager, didUpdateLocation location: CLLocation, with error: Error?) {
        delegate?.didUpdateLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        
        // 에러 처리
        if let error = error {
            delegate?.didFailWithError(error: error)
        }
    }
}
