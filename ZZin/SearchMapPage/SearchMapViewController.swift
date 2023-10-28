import UIKit
import NMapsMap
import CoreLocation
import SnapKit

var companionKeyword : [String] = []
var conditionKeyword : [String] = []
var kindOfFoodKeyword : [String] = []

class SearchMapViewController: UIViewController {
    
    // MARK: - Property
    
    private var searchMapUIView = SearchMapUIView()
    let locationService = LocationService()
    private var currentUserLocation: NMGLatLng?
    private var dataManager = FireStoreManager()
    var user : [User]?
    var review : [Review]?
    var place : [Place]?
    var selectedPlaceID : String?
    var filteredPlace: [Place]?
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
        let matchingVC = MatchingPlaceVC()
        matchingVC.placeID = selectedPlaceID
        navigationController?.pushViewController(matchingVC, animated: true)
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
        searchMapUIView.matchingView.mapButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
        searchMapUIView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        searchMapUIView.searchMapView.mapView.touchDelegate = self
        // 사용자 현재 위치 정보 가져오기 시작
        locationService.startUpdatingLocation()
        setupUI()
        setKeywordView()
        setTouchableCardView()
        addTargetButton()
        dataManager.getPlaceData { result in
            self.place = result
            self.addMarkersForAllPlaces()
        }
        
        FireStoreManager().fetchPlacesWithKeywords(companion: "👯‍♀️친구랑", condition: "✨️인스타 감성", kindOfFood: "🍥일식"){ result in
            switch result {
            case .success(let places):
                print("@@@@@@\(places)")
            case .failure(let error):
                // Handle the error
                print("Failed to fetch places with error: \(error)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentUserLocation = locationService.getCurrentLocation()
        moveCamera(currentUserLocation)
        locationService.stopUpdatingLocation()
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
    
    func addDataToInfoMarker(for place: Place) {
        let location = NMGLatLng(lat: place.lat ?? 0, lng: place.long ?? 0)
        addInfoMarker(at: location, data: place)
    }
    
    func addMarkersForAllPlaces() {
        place?.forEach { addDataToInfoMarker(for: $0) }
    }
    
    func addInfoMarker(at location: NMGLatLng, data: Place) {
        // 1. InfoMarkerView 인스턴스 생성
        let infoMarkerView = InfoMarkerView()
        infoMarkerView.informationLabel.text = data.placeName
        
        // 텍스트의 너비에 따른 마커 뷰의 전체 너비 계산
        let textWidth = infoMarkerView.informationLabel.intrinsicContentSize.width
        let padding: CGFloat = 32 // 기존 패딩 값
        let totalWidth = textWidth + padding
        infoMarkerView.frame = CGRect(x: 0, y: 0, width: totalWidth, height: 25) // height는 기존대로
        
        // InfoMarkerView 레이아웃 강제 업데이트
        infoMarkerView.layoutIfNeeded()
        
        // 2. InfoMarkerView에서 이미지 스냅샷 가져오기
        UIGraphicsBeginImageContextWithOptions(infoMarkerView.bounds.size, false, 0.0)
        infoMarkerView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 3. NMFMarker 생성 및 설정
        let marker = NMFMarker()
        marker.position = location
        marker.iconImage = NMFOverlayImage(image: snapshotImage!)
        marker.anchor = CGPoint(x: 0.5, y: 0.5)
        marker.zIndex = Int.max // 마커 최상단으로 오게 하기 위함
        marker.userInfo = ["Place" : data]
        
        
        
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            
            if let placeData = overlay.userInfo as? [String: Place],
               let placeName = placeData["Place"]?.placeName,
               let reviewID = placeData["Place"]?.rid,
               let placeID = placeData["Place"]?.pid
            {
                self.selectedPlaceID = placeID
                FireStoreManager.shared.fetchDataWithRid(rid: reviewID[0]) { (result) in
                    switch result {
                    case .success(let review):
                        self.searchMapUIView.storeCardView.updateStoreCardView(with: review, reviewCount: reviewID.count)
                        self.searchMapUIView.storeCardView.placeNameLabel.text = placeName
                    case .failure(let error):
                        print("Error fetching review: \(error.localizedDescription)")
                    }
                }
            } else {
                print("마커를 탭했습니다람쥐~")
            }
            return true
        }
        
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

// 지도 빈 영역 터치 시 Delegate
//extension SearchMapViewController : NMFMapViewTouchDelegate {
//    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        print("lat : \(latlng.lat) /// lng : \(latlng.lng)")
//
//    }
//}

extension SearchMapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map을 탭했습니다. 위도: \(latlng.lat), 경도: \(latlng.lng)")
    }
}

extension SearchMapViewController {
    private func setKeywordView(){
        searchMapUIView.matchingView.companionKeywordButton.addTarget(self, action: #selector(firstKeywordButtonTapped), for: .touchUpInside)
        searchMapUIView.matchingView.conditionKeywordButton.addTarget(self, action: #selector(secondKeywordButtonTapped), for: .touchUpInside)
        searchMapUIView.matchingView.kindOfFoodKeywordButton.addTarget(self, action: #selector(menuKeywordButtonTapped), for: .touchUpInside)
    }
    
    // 첫 번째 키워드 버튼이 탭될 때
    @objc func firstKeywordButtonTapped() {
        print("첫 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .with
        keywordVC.noticeLabel.text = "누구랑\n가시나요?"
        keywordVC.matchingKeywordVCdelegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 두 번째 키워드 버튼이 탭될 때
    @objc func secondKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .condition
        keywordVC.noticeLabel.text = "어떤 분위기를\n원하시나요?"
        keywordVC.matchingKeywordVCdelegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 메뉴 키워드 버튼이 탭될 때
    @objc func menuKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .menu
        keywordVC.noticeLabel.text = "메뉴는\n무엇인가요?"
        keywordVC.matchingKeywordVCdelegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    func updateKeywords() {
        print("키워드 업데이트!!!")
        if !companionKeyword.isEmpty {
            searchMapUIView.matchingView.companionKeywordButton.setTitle(companionKeyword[0], for: .normal)
        }
        if !conditionKeyword.isEmpty {
            searchMapUIView.matchingView.conditionKeywordButton.setTitle(conditionKeyword[0], for: .normal)
        }
        if !kindOfFoodKeyword.isEmpty {
            searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitle(kindOfFoodKeyword[0], for: .normal)
        }
    }
}

extension SearchMapViewController: MatchingKeywordVCDelegate {
    func didDismissMatchingKeywordVC() {
        updateKeywords()
    }
}
