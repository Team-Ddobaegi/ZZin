import UIKit
import NMapsMap
import CoreLocation
import SnapKit
import FirebaseStorage

var isMapExist : Bool = false
var isPlaceMap : Bool = false


class SearchMapViewController: UIViewController {
    
    // MARK: - Property
    var companionIndexPath: [IndexPath?]? = []
    var conditionIndexPath: [IndexPath?]? = []
    var kindOfFoodIndexPath: [IndexPath?]? = []
    weak var mapViewDelegate: SearchMapViewControllerDelegate?
    var searchMapUIView = SearchMapUIView()
    private var currentUserLocation: NMGLatLng?
    var cameraLocation: NMGLatLng?
    private var selectedPlaceID : String?
    private var selectedReviewID: [String?]?
    private var filteredPlace: [Place]?
    var companionKeyword : [String?]? = []
    var conditionKeyword : [String?]? = []
    var kindOfFoodKeyword : [String?]? = []
    var address : String?
    private var activeMarkers: [NMFMarker] = []
//    private let pickerView = MatchingLocationPickerView()
    var selectedCity : String?
    var selectedTown : String?
    private var opacityViewAlpha: CGFloat = 1.0 // 1.0은 완전 불투명, 0.0은 완전 투명
    let infoMarkerView = InfoMarkerView()
    let geocodingService = Geocoding.shared

    


    // MARK: - Touch Action
    @objc func backButtonTapped() {
        print("백 버튼 탭탭\(self.selectedCity)\(self.selectedTown)")
        sendDataBackToMatchingViewController()
        removeAllMarkers()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func storeCardTapped() {
        print("storeCardView Tapped")
        let matchingVC = MatchingPlaceVC()
        matchingVC.placeID = selectedPlaceID
        matchingVC.reviewID = selectedReviewID
        navigationController?.pushViewController(matchingVC, animated: true)
    }
    
    @objc func searchCurrentLocationButtonTapped() {
        print("searchCurrentLocationButton Tapped")
        let cameraPosition = searchMapUIView.searchMapView.mapView.cameraPosition
        print("#########\(cameraPosition)")
        let cameraTargetLocation = cameraPosition.target
        searchMapUIView.storeCardView.isHidden = true
        searchMapUIView.searchMapView.searchCurrentLocationButton.isHidden = true
        reverseGeocodeCoordinate(lat: cameraTargetLocation.lat, lng: cameraTargetLocation.lng)
    }
    
    @objc func gpsButtonTapped() {
        print("MoveToCurrentLocation")
        currentUserLocation = LocationService.shared.getCurrentLocation()
        moveCamera(location: currentUserLocation, animation: .linear)
    }
    
    @objc func resetFilterButtonTapped() {
        companionKeyword = []
        conditionKeyword = []
        kindOfFoodKeyword = []
        companionIndexPath = []
        conditionIndexPath = []
        kindOfFoodIndexPath = []
        
        searchMapUIView.matchingView.companionKeywordButton.setTitle("키워드", for: .normal)
        searchMapUIView.matchingView.conditionKeywordButton.setTitle("키워드", for: .normal)
        searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitle("키워드", for: .normal)
        
        removeAllMarkers()
        fetchPlacesWithKeywords()
        print("확인 버튼 탭탭\(self.selectedCity)\(self.selectedTown)")
        sendDataBackToMatchingViewController()
        updateResetButtonStatus()
    }
    
    @objc private func setPickerViewTapped() {
        print("위치 설정 피커뷰 탭")

        let locationPickerVC = MatchingLocationPickerVC()
        locationPickerVC.pickerViewDelegate = self

        if let sheet = locationPickerVC.sheetPresentationController {
            configureSheetPresentation(sheet)
        }
        present(locationPickerVC, animated: true)
    }

    // MARK: - addTarget
    
    func sendDataBackToMatchingViewController() {
        mapViewDelegate?.didUpdateSearchData(companionKeyword: companionKeyword, conditionKeyword: conditionKeyword, kindOfFoodKeyword: kindOfFoodKeyword, companionIndexPath: companionIndexPath, conditionIndexPath: conditionIndexPath, kindOfFoodIndexPath: kindOfFoodIndexPath, selectedCity: selectedCity, selectedTown: selectedTown)
    }
    
    func setTouchableCardView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(storeCardTapped))
        searchMapUIView.storeCardView.addGestureRecognizer(tapGesture)
        searchMapUIView.storeCardView.isUserInteractionEnabled = true
    }
    
    func addTargetButton() {
        searchMapUIView.matchingView.resetFilterButton.addTarget(self, action: #selector(resetFilterButtonTapped), for: .touchUpInside)
        searchMapUIView.gpsButton.addTarget(self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        searchMapUIView.gpsButton.isExclusiveTouch = true
        searchMapUIView.searchMapView.searchCurrentLocationButton.addTarget(self, action: #selector(searchCurrentLocationButtonTapped), for: .touchUpInside)
        searchMapUIView.matchingView.locationButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setPickerView(){
        searchMapUIView.matchingView.setLocationButton.addTarget(self, action: #selector(setPickerViewTapped), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isMapExist = true
        LocationService.shared.delegate = self
        searchMapUIView.searchMapView.mapView.touchDelegate = self
        searchMapUIView.searchMapView.mapView.addCameraDelegate(delegate: self)
        searchMapUIView.searchMapView.searchCurrentLocationButton.isHidden = true
        setupUI()
        setKeywordView()
        setTouchableCardView()
        addTargetButton()
        setKeywordButtonTitle()
        setPickerView()
        currentUserLocation = LocationService.shared.getCurrentLocation()
        if isPlaceMap {
            print("맛집 위치로 이동합니두!")
            moveCamera(location: cameraLocation, animation: .none)
            isPlaceMap = false
        } else {
            moveCamera(location: currentUserLocation, animation: .none)
        }
        fetchPlacesWithKeywords()
        updateLocationTitle()
        updateResetButtonStatus()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCameraSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if isPlaceMap {
            moveCamera(location: cameraLocation, animation: .none)
            isPlaceMap = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        print("ViewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit{
        print("deinit SearchMapViewController")
        isMapExist = false
    }
    
    // MARK: - UI Setting
    
    func setKeywordButtonTitle() {
        let firstCompanionKeyword = companionKeyword?.first ?? nil ?? nil
        print("#######\(firstCompanionKeyword)")
        searchMapUIView.matchingView.companionKeywordButton.setTitle(firstCompanionKeyword ?? "키워드", for: .normal)
        searchMapUIView.matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
        
        let firstConditionKeyword = conditionKeyword?.first ?? nil ?? nil
        searchMapUIView.matchingView.conditionKeywordButton.setTitle(firstConditionKeyword ?? "키워드", for: .normal)
        searchMapUIView.matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
        
        let firstKindOfFoodKeyword = kindOfFoodKeyword?.first ?? nil ?? nil
        searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitle(firstKindOfFoodKeyword ?? "키워드", for: .normal)
        searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
    }
    
    private func updateLocationTitle() {
        searchMapUIView.matchingView.setLocationButton.setTitle("\(self.selectedCity ?? "지역") \(self.selectedTown ?? "미설정")", for: .normal)
    }
    
    
    func moveCamera(location: NMGLatLng?, animation: NMFCameraUpdateAnimation) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: location ?? NMGLatLng(lat: 37.5666102, lng: 126.9783881))
        cameraUpdate.animation = animation
        cameraUpdate.animationDuration = 0.3
        searchMapUIView.searchMapView.mapView.moveCamera(cameraUpdate)
    }
    
    func setCameraSetting() {
        searchMapUIView.searchMapView.mapView.minZoomLevel = 5.0
//        searchMapUIView.searchMapView.mapView.maxZoomLevel = 18.0
        searchMapUIView.searchMapView.mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    
    // MARK: - setupUI
    func setupUI() {
        searchMapUIView.storeCardView.isHidden = true
        view.backgroundColor = .white
        view.addSubview(searchMapUIView)
        searchMapUIView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Marker
    
    private func configureSheetPresentation(_ sheet: UISheetPresentationController) {
        sheet.preferredCornerRadius = 15
        sheet.prefersGrabberVisible = true

        if #available(iOS 16.0, *) {
            sheet.detents = [.custom { $0.maximumDetentValue * 0.65 }]
        }
        sheet.largestUndimmedDetentIdentifier = .large
    }
    
    func addDataToInfoMarker(for place: Place) {
        let location = NMGLatLng(lat: place.lat ?? 0, lng: place.long ?? 0)
        addInfoMarker(at: location, data: place)
    }
    
    func addMarkersForAllPlaces() {
        filteredPlace?.forEach { addDataToInfoMarker(for: $0) }
    }
    
    func removeAllMarkers() {
        for marker in activeMarkers {
            marker.mapView = nil
        }
        activeMarkers.removeAll()
    }
    
    func updateResetButtonStatus() {
        if companionKeyword == [] && conditionKeyword == [] && kindOfFoodKeyword == [] {
            searchMapUIView.matchingView.resetFilterButton.isEnabled = false
            searchMapUIView.matchingView.resetFilterButton.layer.borderColor = UIColor.systemGray.cgColor
        } else {
            searchMapUIView.matchingView.resetFilterButton.isEnabled = true
            searchMapUIView.matchingView.resetFilterButton.layer.borderColor = ColorGuide.main.cgColor
        }
    }
    
    func addInfoMarker(at location: NMGLatLng, data: Place) {
        infoMarkerView.informationLabel.text = data.placeName
        
        // 텍스트의 너비에 따른 마커 뷰의 전체 너비 계산
        let textWidth = infoMarkerView.informationLabel.intrinsicContentSize.width
        let padding: CGFloat = 32 // 기존 패딩 값
        let totalWidth = textWidth + padding
        infoMarkerView.frame = CGRect(x: 0, y: 0, width: totalWidth, height: 25) // height는 기존대로
        
        // InfoMarkerView 레이아웃 강제 업데이트
        infoMarkerView.layoutIfNeeded()
        
        // InfoMarkerView에서 이미지 스냅샷 가져오기
        UIGraphicsBeginImageContextWithOptions(infoMarkerView.bounds.size, false, 0.0)
        infoMarkerView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // NMFMarker 생성 및 설정
        let marker = NMFMarker()
        marker.position = location
        marker.iconImage = NMFOverlayImage(image: snapshotImage!)
        marker.anchor = CGPoint(x: 0.5, y: 0.5)
        marker.zIndex = Int.max
        marker.userInfo = ["Place": data]
        marker.touchHandler = handleMarkerTouch(overlay:)
        // 마커를 지도에 추가
        marker.mapView = searchMapUIView.searchMapView.mapView
        // 활성화된 마커 배열에 추가
        activeMarkers.append(marker)
    }
    
    func handleMarkerTouch(overlay: NMFOverlay) -> Bool {
        if let placeData = overlay.userInfo as? [String: Place],
           let placeName = placeData["Place"]?.placeName,
           let reviewID = placeData["Place"]?.rid,
           let placeID = placeData["Place"]?.pid,
           let placeLat = placeData["Place"]?.lat,
           let placeLong = placeData["Place"]?.long,
           let placeImgPath = placeData["Place"]?.placeImg,
           let placeAddress = placeData["Place"]?.address
        {
            self.searchMapUIView.storeCardView.isHidden = false
            self.selectedReviewID = reviewID
            self.selectedPlaceID = placeID
            FireStoreManager.shared.fetchDataWithRid(rid: reviewID[0]) { (result) in
                switch result {
                case .success(let review):
                    self.searchMapUIView.storeCardView.updateStoreCardView(with: review, reviewCount: reviewID.count)
                    self.searchMapUIView.storeCardView.placeNameLabel.text = placeName
                    self.searchMapUIView.storeCardView.placeAddressLabel.text = placeAddress
                    print("$$$$$$\(placeAddress)")
                    FireStorageManager().bindPlaceImgWithPath(path: placeImgPath[0], imageView: self.searchMapUIView.storeCardView.placeImage)
                    self .cameraLocation = NMGLatLng(lat: placeLat, lng: placeLong)
                    let location = NMGLatLng(lat: placeLat, lng: placeLong)
                    self.moveCamera(location: location, animation: .linear)
                    print("===========\(placeID)")
                case .failure(let error):
                    print("Error fetching review: \(error.localizedDescription)")
                }
            }
        } else {
            print("마커를 탭했습니다람쥐~")
        }
        return true
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

extension SearchMapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map을 탭했습니다. 위도: \(latlng.lat), 경도: \(latlng.lng)")
    }
}

extension SearchMapViewController {
    private func setKeywordView(){
        searchMapUIView.matchingView.companionKeywordButton.addTarget(self, action: #selector(companionKeywordButtonTapped), for: .touchUpInside)
        searchMapUIView.matchingView.conditionKeywordButton.addTarget(self, action: #selector(conditionKeywordButtonTapped), for: .touchUpInside)
        searchMapUIView.matchingView.kindOfFoodKeywordButton.addTarget(self, action: #selector(kindOfFoodKeywordButtonTapped), for: .touchUpInside)
    }
    
    @objc func companionKeywordButtonTapped() {
        print("첫 번째 키워드 버튼이 탭됨")
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .companion
        keywordVC.matchingKeywordView.noticeLabel.text = "누구랑\n가시나요?"
        keywordVC.delegate = self
        
        let indexPath = self.companionIndexPath
        if let indexPath = indexPath?.compactMap({ $0 }) {
            keywordVC.selectedCompanionIndexPath = indexPath.isEmpty ? [] : indexPath
            print("~~ companion 선택된 인덱스 있음두 ~~", indexPath)
        } else {
            // indexPath가 nil이거나 배열에 값이 없는 경우
            keywordVC.selectedCompanionIndexPath = []
            print("~~ companion 선택된 인덱스 없어유 ~~", indexPath)
        }
        present(keywordVC, animated: true)
    }
    
    @objc func conditionKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .condition
        keywordVC.matchingKeywordView.noticeLabel.text = "어떤 분위기를\n원하시나요?"
        keywordVC.delegate = self
        
        let indexPath = self.conditionIndexPath
        if let indexPath = indexPath?.compactMap({ $0 }) {
            keywordVC.selectedConditionIndexPath = indexPath.isEmpty ? [] : indexPath
            print("~~ condition 선택된 인덱스 있음두 ~~", indexPath)
        } else {
            // indexPath가 nil이거나 배열에 값이 없는 경우
            keywordVC.selectedConditionIndexPath = []
            print("~~ condition 선택된 인덱스 없어유 ~~", indexPath)
        }
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    @objc func kindOfFoodKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .kindOfFood
        keywordVC.matchingKeywordView.noticeLabel.text = "메뉴는\n무엇인가요?"
        keywordVC.delegate = self
        
        let indexPath = self.kindOfFoodIndexPath
        if let indexPath = indexPath?.compactMap({ $0 }) {
            keywordVC.selectedKindOfFoodIndexPath = indexPath.isEmpty ? [] : indexPath
            print("~~ kindOfFood 선택된 인덱스 있음두 ~~", indexPath)
        } else {
            // indexPath가 nil이거나 배열에 값이 없는 경우
            keywordVC.selectedKindOfFoodIndexPath = []
            print("~~ kindOfFood 선택된 인덱스 없어유 ~~", indexPath)
        }
        
        navigationController?.present(keywordVC, animated: true)
    }
}

extension SearchMapViewController: MatchingKeywordDelegate {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType, indexPath: [IndexPath]) {

        switch keywordType {
        case .companion:
            if let updateKeyword = keyword.first {
                searchMapUIView.matchingView.companionKeywordButton.setTitle(updateKeyword, for: .normal)
                searchMapUIView.matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.companionKeyword = [updateKeyword as String?]
                self.companionIndexPath = indexPath
//                print("~~ companion 인덱스 전달 받았음두", indexPath)

            } else if indexPath.isEmpty {
                self.companionIndexPath = []
                self.conditionKeyword = []
                print("~~ companion 인덱스는 없어!", self.companionIndexPath as Any)

                searchMapUIView.matchingView.companionKeywordButton.setTitle("키워드", for: .normal)
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                searchMapUIView.matchingView.conditionKeywordButton.setTitle(updateKeyword, for: .normal)
                searchMapUIView.matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.conditionKeyword = [updateKeyword as String?]
                self.conditionIndexPath = indexPath
//                print("~~ condition 인덱스 전달 받았음두", indexPath)
                
            } else if indexPath.isEmpty {
                self.conditionIndexPath = []
                self.conditionKeyword = []
                searchMapUIView.matchingView.conditionKeywordButton.setTitle("키워드", for: .normal)
                print("~~ condition 인덱스는 없어!", self.conditionIndexPath as Any)

            }
            
        case .kindOfFood:
            if let updateKeyword = keyword.first {
                searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitle(updateKeyword, for: .normal)
                searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.kindOfFoodKeyword = [updateKeyword as String?]
                self.kindOfFoodIndexPath = indexPath
//                print("~~ kindOfFood 인덱스 전달 받았음두", indexPath)
                
            } else if indexPath.isEmpty {
                self.kindOfFoodIndexPath = []
                self.kindOfFoodKeyword = []
                searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitle("키워드", for: .normal)
                print("~~ kindOfFood 인덱스는 없어!", self.kindOfFoodIndexPath as Any)
            }
        }
      
        fetchPlacesWithKeywords()
        updateResetButtonStatus()
    }
    
    
}

extension SearchMapViewController {
    func fetchPlacesWithKeywords(companion: String? = nil, condition: String? = nil, kindOfFood: String? = nil, city: String? = nil, town: String? = nil) {
        let actualCompanion = companion ?? self.companionKeyword?.first ?? nil
        let actualCondition = condition ?? self.conditionKeyword?.first ?? nil
        let actualKindOfFood = kindOfFood ?? self.kindOfFoodKeyword?.first ?? nil
        let actualCity = city ?? self.selectedCity ?? nil
        let actualTown = town ?? self.selectedTown
        print("@@@@@@@##\(actualCity)\(actualTown)")
        FireStoreManager().fetchPlacesWithKeywords(companion: actualCompanion, condition: actualCondition, kindOfFood: actualKindOfFood, city: actualCity, town: actualTown) { result in
            switch result {
            case .success(let places):
                
                self.filteredPlace = places
                print(self.filteredPlace?.count)
                self.removeAllMarkers()
                self.addMarkersForAllPlaces()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func geocodeAddress(query: String, lat: Double, lng: Double) {
        Geocoding.shared.geocodeAddress(query: query, coordinate: "\(lat),\(lng)") { (response, error) in
            if let response = response {
                // 성공적으로 주소를 좌표로 변환한 경우
                print("Status: \(response.status)")
                print("Road Address: \(response.addresses.first?.roadAddress ?? "")")
                print("X Coordinate: \(response.addresses.first?.x ?? "")")
                print("Y Coordinate: \(response.addresses.first?.y ?? "")")
            } else if let error = error {
                // 오류 발생한 경우
                print("Geocoding Error: \(error.localizedDescription)")
            } else {
                // 주소를 찾을 수 없는 경우
                print("주소를 찾을 수 없음")
            }
        }
    }
    
    func reverseGeocodeCoordinate(lat: Double, lng: Double) {
        Geocoding.shared.reverseGeocodeCoordinate(coordinate: (lat: lat, lng: lng)) { detailedAddress, error in
            if let detailedAddress = detailedAddress {
                // 변환된 주소 정보를 사용하는 코드
                print("Reverse Geocoded Address: \(detailedAddress)")
                let components = detailedAddress.components(separatedBy: " ")
                if components.count >= 2 {
                    let city = components[0]
                    self.selectedCity = String(city.prefix(2))
                    self.selectedTown = components[1]
                }
                self.searchMapUIView.matchingView.setLocationButton.setTitle("\(self.selectedCity ?? "") \(self.selectedTown ?? "")", for: .normal)
                self.fetchPlacesWithKeywords()
            } else if let error = error {
                // 오류 처리 코드
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

protocol SearchMapViewControllerDelegate: AnyObject {
    func didUpdateSearchData(companionKeyword : [String?]?, conditionKeyword : [String?]?, kindOfFoodKeyword : [String?]?, companionIndexPath : [IndexPath?]?, conditionIndexPath: [IndexPath?]?, kindOfFoodIndexPath: [IndexPath?]?, selectedCity: String?, selectedTown: String?)
}

extension SearchMapViewController: LocationPickerViewDelegate {
    func updateLocation(city: String?, town: String?) {
        let selectedCity = city
        let selectedTown = town
        
        // 피커뷰에서 선택된 지역으로 타이틀 업데이트
        self.selectedCity = selectedCity
        self.selectedTown = selectedTown
        searchMapUIView.matchingView.setLocationButton.setTitle("\(selectedCity ?? "") \(selectedTown ?? "")", for: .normal)

        
        print("#######\(self.selectedCity)\(self.selectedTown)")

        // 선택 지역으로 컬렉션뷰 리로드
        fetchPlacesWithKeywords()
        if let town = self.selectedTown,
           let selectedTownEnum = SeoulDistrictOfficeCoordinates.find(for: town) {
            let coords = selectedTownEnum.coordinate
            print("\(selectedTown) 좌표: 위도 \(coords.latitude), 경도 \(coords.longitude)")
            let officeCoords = NMGLatLng(lat: coords.latitude, lng: coords.longitude)
            moveCamera(location: officeCoords, animation: .none)
        } else {
            print("일치하는 구청 좌표를 찾을 수 없습니다.")
        }
    }
}

extension SearchMapViewController: NMFMapViewCameraDelegate {
    // NMFMapViewCameraDelegate 메서드 구현
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 카메라 변경 감지 로직
        searchMapUIView.searchMapView.searchCurrentLocationButton.isHidden = false
    }
}
