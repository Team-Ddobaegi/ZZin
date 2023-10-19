import UIKit
import NMapsMap
import SnapKit

class SearchMapViewController: UIViewController, LocationServiceDelegate {
    
    // MARK: - Property
    private var searchView = SearchView()
    private var storeCardView = StoreCardView()
    private var locationService = LocationService()
    private var searchMapView = SearchMapView()
    private var currentUserLocation = NMGLatLng()
    
    private lazy var backButton = UIButton().then {
        let iconImage = UIImage(systemName: "arrowshape.backward.fill")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemRed
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private lazy var searchCurrentLocationButton = UIButton().then {
        $0.setTitle("이 지역에서 재검색", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.backgroundColor = .systemRed
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(searchCurrentLocationButtonTapped), for: .touchUpInside)
    }
    
    private lazy var gpsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        let gpsIcon = UIImage(systemName: "location.fill")
        button.setImage(gpsIcon, for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 5
        button.clipsToBounds = false
        return button
    }()

    private lazy var currentLocationButton = UIButton().then {
        let button = UIButton()
        $0.setTitle("이 지역에서 재검색", for: .normal)
    }
    
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
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationService.delegate = self
        locationService.startUpdatingLocation()
        
        changeSearchView()
        setupUI()
        setTouchableCardView()
        setCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func didUpdateLocation(lat: Double, lng: Double) {
        let center = NMGLatLng(lat: lat, lng: lng)
        searchMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: center))
    }
    
    func setCamera() {
        let initialLocation = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        let cameraUpdate = NMFCameraUpdate(scrollTo: initialLocation)
        searchMapView.mapView.moveCamera(cameraUpdate)
    }
    
    // MARK: - UI Setting
    func changeSearchView() {
        searchView.mapButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
        searchView.mapButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
    }
    
    func setTouchableCardView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(storeCardTapped))
            storeCardView.addGestureRecognizer(tapGesture)
            storeCardView.isUserInteractionEnabled = true
    }
    
    
    func setupUI() {
        let mapView = SearchMapView(frame: view.frame)
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.mapView = mapView.mapView
        
        view.backgroundColor = .white
        
        
        view.addSubview(searchView)
        view.addSubview(mapView)
        searchView.addSubview(backButton)
        mapView.addSubview(storeCardView)
        mapView.addSubview(searchCurrentLocationButton)
        mapView.addSubview(gpsButton)

        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(232)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(searchView.mapButton.snp.centerY)
            $0.leading.equalToSuperview().offset(20)
        }
        
        storeCardView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
        searchCurrentLocationButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(180)
        }
        
        gpsButton.snp.makeConstraints {
            $0.bottom.equalTo(storeCardView.snp.top).offset(-15)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(40)
        }
    }
}


