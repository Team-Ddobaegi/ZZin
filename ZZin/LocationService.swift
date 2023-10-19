import NMapsMap

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(lat: Double, lng: Double)
}

class LocationService: NSObject, NMFLocationManagerDelegate {
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
    
    // NMFLocationManagerDelegate
    func locationManager(_ locationManager: NMFLocationManager, didUpdate location: NMGLatLng) {
        delegate?.didUpdateLocation(lat: location.lat, lng: location.lng)
    }
}
