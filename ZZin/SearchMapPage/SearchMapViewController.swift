import UIKit
import NMapsMap
import CoreLocation
import SnapKit

class SearchMapViewController: UIViewController {
    
    // MARK: - Property
    
    private var searchMapUIView = SearchMapUIView()
    
    let locationService = LocationService()
    private var currentUserLocation: NMGLatLng?
    
    // MARK: - Touch Action
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gridButtonTapped() {
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.pushViewController(MatchingVC(), animated: true)
    }
    
    @objc func storeCardTapped() {
        print("storeCardView Tapped")
    }
    
    @objc func searchCurrentLocationButtonTapped() {
        print("searchCurrentLocationButton Tapped")
    }
    
    @objc func gpsButtonTapped() {
        print("MoveToCurrentLocation")
        currentUserLocation = locationService.getCurrentLocation()
        moveCamera(currentUserLocation)
    }
    
    func setTouchableCardView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(storeCardTapped))
        searchMapUIView.storeCardView.addGestureRecognizer(tapGesture)
        searchMapUIView.storeCardView.isUserInteractionEnabled = true
    }
    
    func addTargetButton() {
        searchMapUIView.gpsButton.addTarget(self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        searchMapUIView.gpsButton.isExclusiveTouch = true
        searchMapUIView.searchMapView.searchCurrentLocationButton.addTarget(self, action: #selector(searchCurrentLocationButtonTapped), for: .touchUpInside)
        searchMapUIView.searchView.mapButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
        searchMapUIView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        // 사용자 현재 위치 정보 가져오기 시작
        locationService.startUpdatingLocation()
        setupUI()
        setTouchableCardView()
        addTargetButton()
        addInfoMarker(at: NMGLatLng(lat: 37.5666102, lng: 126.9783881), storeName: "가게 이름")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentUserLocation = locationService.getCurrentLocation()
        moveCamera(currentUserLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - UI Setting
    
    func moveCamera(_ location: NMGLatLng?) {
        //        let cameraUpdate = NMFCameraUpdate(scrollTo: location!)
        let cameraUpdate = NMFCameraUpdate(scrollTo: location ?? NMGLatLng(lat: 37.5666102, lng: 126.9783881))
        searchMapUIView.searchMapView.mapView.moveCamera(cameraUpdate)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchMapUIView)
        searchMapUIView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addInfoMarker(at location: NMGLatLng, storeName: String) {
        let infoMarkerWidth = 24 + 8 + 16
        let infoMarkerHeight = 24
        
        // 1. InfoMarkerView 인스턴스 생성
        let infoMarkerView = InfoMarkerView(frame: CGRect(x: 0, y: 0, width: infoMarkerWidth, height: infoMarkerHeight))
        infoMarkerView.informationLabel.text = storeName
        
        // 2. InfoMarkerView에서 이미지 스냅샷 가져오기
        UIGraphicsBeginImageContextWithOptions(infoMarkerView.bounds.size, false, 0.0)
        infoMarkerView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 3. NMFMarker 생성 및 설정
        let marker = NMFMarker()
        marker.position = location
        marker.iconImage = NMFOverlayImage(image: snapshotImage!)
        
        // 4. 마커를 지도에 추가
        marker.mapView = searchMapUIView.searchMapView.mapView
    }
    
}

// MARK: - LocationServiceDelegate

extension SearchMapViewController: LocationServiceDelegate {
    func didUpdateLocation(lat latitude: Double, lng longitude: Double) {
        currentUserLocation = NMGLatLng(lat: latitude, lng: longitude)
        print("위치 업데이트!")
        print("위도 : \(currentUserLocation?.lat)")
        print("경도 : \(currentUserLocation?.lng)")
    }
    
    func didFailWithError(error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

extension SearchMapViewController : NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("lat : \(latlng.lat) /// lng : \(latlng.lng)")
    }
}
