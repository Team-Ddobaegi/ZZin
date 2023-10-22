import UIKit
import NMapsMap
import CoreLocation
import SnapKit

class SearchMapViewController: UIViewController{
    // MARK: - Property
    private var searchView = SearchView()
    private var storeCardView = StoreCardView()
    private var searchMapView = SearchMapView()
    let locationService = LocationService()
    private var currentUserLocation: NMGLatLng?

    

    private lazy var backButton = UIButton().then {
        let iconImage = UIImage(systemName: "arrowshape.backward.fill")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemRed
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private lazy var currentLocationButton = UIButton().then {
        let button = UIButton()
        $0.setTitle("이 지역에서 재검색", for: .normal)
    }

    lazy var gpsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        let gpsIcon = UIImage(systemName: "location.fill")
        button.setImage(gpsIcon, for: .normal)
        button.tintColor = .systemRed
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 5
        button.clipsToBounds = false
        return button
    }()
    
    // MARK: - Action
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gridButtonTapped() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
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
        var cameraUpdate = NMFCameraUpdate(scrollTo: currentUserLocation!)
        searchMapView.mapView.moveCamera(cameraUpdate)
    }

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        changeSearchView()
        setupUI()
        setTouchableCardView()
        addTargetMapViewButton()
        // 사용자 현재 위치 정보 가져오기 시작
        locationService.startUpdatingLocation()
        
        var cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5666102, lng: 126.9783881))
        searchMapView.mapView.moveCamera(cameraUpdate)

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
    func changeSearchView() {
        searchView.mapButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
        searchView.mapButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
        
    }
    
    func addTargetMapViewButton() {
        gpsButton.addTarget(self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        gpsButton.isExclusiveTouch = true
        searchMapView.searchCurrentLocationButton.addTarget(self, action: #selector(searchCurrentLocationButtonTapped), for: .touchUpInside)
    }
    
    func setTouchableCardView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(storeCardTapped))
            storeCardView.addGestureRecognizer(tapGesture)
            storeCardView.isUserInteractionEnabled = true
    }
    
    
    func setupUI() {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.mapView = searchMapView.mapView
        
        view.backgroundColor = .white
        
        
        view.addSubview(searchView)
        view.addSubview(searchMapView)
        searchView.addSubview(backButton)
        searchMapView.addSubview(storeCardView)
        searchMapView.addSubview(gpsButton)

        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(232)
        }
        
        searchMapView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(searchView.mapButton.snp.centerY)
            $0.leading.equalToSuperview().offset(20)
        }
        
        gpsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-200)
        }
        
        storeCardView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
    }
}

extension SearchMapViewController: LocationServiceDelegate {
    func didUpdateLocation(lat latitude: Double, lng longitude: Double) {
        currentUserLocation = NMGLatLng(lat: latitude, lng: longitude)
        print("위치 업데이트!")
        print("위도 : \(currentUserLocation?.lat)")
        print("경도 : \(currentUserLocation?.lng)")
    }
    
    func didFailWithError(error: Error) {
        // 오류 처리 (알림 표시 등)
        print("Failed to get location: \(error.localizedDescription)")
    }
}





