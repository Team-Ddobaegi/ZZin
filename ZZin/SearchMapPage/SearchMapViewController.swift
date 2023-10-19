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
        
        view.backgroundColor = .darkGray
        
        
        view.addSubview(searchView)
        view.addSubview(mapView)
        searchView.addSubview(backButton)
        mapView.addSubview(storeCardView)

        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(247)
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
    }
}


