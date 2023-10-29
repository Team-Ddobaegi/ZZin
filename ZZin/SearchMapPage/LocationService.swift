import UIKit
import CoreLocation
import NMapsMap

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(lat: Double, lng: Double)
    func didFailWithError(error: Error)
}

class LocationService: NSObject, NMFLocationManagerDelegate, CLLocationManagerDelegate {
    
    static let shared = LocationService()

    private var locationManager: NMFLocationManager
    weak var delegate: LocationServiceDelegate?
    private let geocoder = CLGeocoder()

    private override init() {
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
    
    func getAddressFromLocation(lat: Double, lng: Double, completion: @escaping ([String]?, Error?) -> Void) {
        let location = CLLocation(latitude: lat, longitude: lng)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let placemark = placemarks?.first, let addressDictionary = placemark.addressDictionary as? [String: Any] {
                print(addressDictionary)
                
                let city = placemark.locality ?? ""
                var town = ""
                
                // FormattedAddressLines에서 '구' 정보 추출
                if let addressLines = addressDictionary["FormattedAddressLines"] as? [String], addressLines.count > 1 {
                    let components = addressLines[1].split(separator: ",")
                    if components.count > 0 {
                        town = components[0].trimmingCharacters(in: .whitespaces)
                    }
                }
                
                completion([city, town], nil)
            } else {
                completion(nil, nil)
            }
        }
    }


}
