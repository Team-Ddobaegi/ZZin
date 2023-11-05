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
                
                if let addressLines = addressDictionary["FormattedAddressLines"] as? [String], let fullAddress = addressLines.first {
                    let components = fullAddress.split(separator: " ")
                    
                    var city = ""
                    var district = ""
                    
                    if components.count > 1 {
                        city = String(components[1]).replacingOccurrences(of: "특별시", with: "")
                        city = city.replacingOccurrences(of: "광역시", with: "")
                    }
                    
                    if components.count > 2 {
                        district = String(components[2])
                    }
                    
                    completion([city, district], nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }





}
