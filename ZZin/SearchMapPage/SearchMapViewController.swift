import UIKit
import NMapsMap
import CoreLocation
import SnapKit
import FirebaseStorage

class SearchMapViewController: UIViewController {
    
    // MARK: - Property
    weak var mapViewDelegate: SearchMapViewControllerDelegate?
    private var searchMapUIView = SearchMapUIView()
    private var currentUserLocation: NMGLatLng?
    var selectedPlaceID : String?
    var filteredPlace: [Place]?
    var companionKeyword : [String?]?
    var conditionKeyword : [String?]?
    var kindOfFoodKeyword : [String?]?
    var selectedCity : String?
    var selectedTown : String?
    private var activeMarkers: [NMFMarker] = []
    private let pickerView = MatchingLocationPickerView()
    private let opacityView = OpacityView()
    private var opacityViewAlpha: CGFloat = 1.0 // 1.0은 완전 불투명, 0.0은 완전 투명


    // MARK: - Touch Action
    
    @objc func backButtonTapped() {
        print("백 버튼 탭탭\(self.selectedCity)\(self.selectedTown)")
        sendDataBackToMatchingViewController()
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
        currentUserLocation = LocationService.shared.getCurrentLocation()
        moveCamera(location: currentUserLocation, animation: .linear)
    }
    
    @objc func resetFilterButtonTapped() {
        companionKeyword = [nil]
        conditionKeyword = [nil]
        kindOfFoodKeyword = [nil]
//        selectedCity = nil
//        selectedTown = "전체"
        
        searchMapUIView.matchingView.companionKeywordButton.setTitle("키워드", for: .normal)
        searchMapUIView.matchingView.conditionKeywordButton.setTitle("키워드", for: .normal)
        searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitle("키워드", for: .normal)
        
        removeAllMarkers()
        fetchPlacesWithKeywords()
        updateResetButtonStatus()
        print("확인 버튼 탭탭\(self.selectedCity)\(self.selectedTown)")
        sendDataBackToMatchingViewController()
    }
    // MARK: - addTarget
    
    func sendDataBackToMatchingViewController() {
        mapViewDelegate?.didUpdateSearchData(companionKeyword: companionKeyword, conditionKeyword: conditionKeyword, kindOfFoodKeyword: kindOfFoodKeyword, selectedCity: self.selectedCity, selectedTown: self.selectedTown)
    }
    
    func setTouchableCardView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(storeCardTapped))
        searchMapUIView.storeCardView.addGestureRecognizer(tapGesture)
        searchMapUIView.storeCardView.isUserInteractionEnabled = true
    }
    
    func addTargetButton() {
        searchMapUIView.resetFilterButton.addTarget(self, action: #selector(resetFilterButtonTapped), for: .touchUpInside)
        searchMapUIView.gpsButton.addTarget(self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        searchMapUIView.gpsButton.isExclusiveTouch = true
        searchMapUIView.searchMapView.searchCurrentLocationButton.addTarget(self, action: #selector(searchCurrentLocationButtonTapped), for: .touchUpInside)
        searchMapUIView.matchingView.mapButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
        searchMapUIView.matchingView.locationButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.shared.delegate = self
        searchMapUIView.searchMapView.mapView.touchDelegate = self
        setupUI()
        updateResetButtonStatus()
        setKeywordView()
        setTouchableCardView()
        addTargetButton()
        setKeywordButtonTitle()
        setPickerView()
        setOpacityView()
        updateLocationTitle()
        
        print("\(String(describing: self.selectedCity)),\(String(describing: self.selectedTown))---------------")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentUserLocation = LocationService.shared.getCurrentLocation()
        moveCamera(location: currentUserLocation, animation: .none)
        fetchPlacesWithKeywords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit{
        print("deinit SearchMapViewController")
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
    
    // MARK: - setupUI
    func setupUI() {
        searchMapUIView.storeCardView.isHidden = true
        
        view.backgroundColor = .white
        view.addSubview(searchMapUIView)
        view.addSubview(opacityView)

        searchMapUIView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        opacityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
        if companionKeyword == nil && conditionKeyword == nil && kindOfFoodKeyword == nil {
            searchMapUIView.resetFilterButton.isEnabled = false
        } else {
            searchMapUIView.resetFilterButton.isEnabled = true
        }
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
               let placeID = placeData["Place"]?.pid,
               let placeLat = placeData["Place"]?.lat,
               let placeLong = placeData["Place"]?.long
            {
                self.searchMapUIView.storeCardView.isHidden = false
                self.selectedPlaceID = placeID
                FireStoreManager.shared.fetchDataWithRid(rid: reviewID[0]) { (result) in
                    switch result {
                    case .success(let review):
                        self.searchMapUIView.storeCardView.updateStoreCardView(with: review, reviewCount: reviewID.count)
                        self.searchMapUIView.storeCardView.placeNameLabel.text = placeName
                        FireStorageManager().downloadImgFromStorage(useage: .review, id: reviewID[0], imageView: self.searchMapUIView.storeCardView.placeImage)
                        let location = NMGLatLng(lat: placeLat , lng: placeLong)
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
        // 4. 마커를 지도에 추가
        marker.mapView = searchMapUIView.searchMapView.mapView
        // 5. 활성화된 마커 배열에 추가
        activeMarkers.append(marker)
        
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
        keywordVC.delegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 두 번째 키워드 버튼이 탭될 때
    @objc func secondKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .condition
        keywordVC.noticeLabel.text = "어떤 분위기를\n원하시나요?"
        keywordVC.delegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 메뉴 키워드 버튼이 탭될 때
    @objc func menuKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .menu
        keywordVC.noticeLabel.text = "메뉴는\n무엇인가요?"
        keywordVC.delegate = self
        navigationController?.present(keywordVC, animated: true)
    }
}



extension SearchMapViewController: MatchingKeywordDelegate {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType) {
        let keywordType = keywordType
        
        switch keywordType {
        case .with:
            if let updateKeyword = keyword.first {
                searchMapUIView.matchingView.companionKeywordButton.setTitle(updateKeyword, for: .normal)
                searchMapUIView.matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.companionKeyword = [updateKeyword as String?]
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                searchMapUIView.matchingView.conditionKeywordButton.setTitle(updateKeyword, for: .normal)
                searchMapUIView.matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.conditionKeyword = [updateKeyword as String?]
            }
            
        case .menu:
            if let updateKeyword = keyword.first {
                searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitle(updateKeyword, for: .normal)
                searchMapUIView.matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.kindOfFoodKeyword = [updateKeyword as String?]
            }
        }
        removeAllMarkers()
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
        let actualTown = town ?? self.selectedTown ?? "전체"
        print("@@@@@@@\(actualCity)\(actualTown)")
        FireStoreManager().fetchPlacesWithKeywords(companion: actualCompanion, condition: actualCondition, kindOfFood: actualKindOfFood, city: actualCity, town: actualTown) { result in
            switch result {
            case .success(let places):
                
                self.filteredPlace = places
                print(self.filteredPlace?.count)
                self.addMarkersForAllPlaces()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

protocol SearchMapViewControllerDelegate: AnyObject {
    func didUpdateSearchData(companionKeyword : [String?]?, conditionKeyword : [String?]?, kindOfFoodKeyword : [String?]?, selectedCity : String?, selectedTown : String?)
}

extension SearchMapViewController {
    
    private func setPickerView(){
        searchMapUIView.matchingView.setLocationButton.addTarget(self, action: #selector(setPickerViewTapped), for: .touchUpInside)
        pickerView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func setPickerViewTapped() {
        print("지역 설정 피커뷰 탭")
        setPickerViewAttribute()
        
        UIView.animate(withDuration: 0.1) {
            self.opacityViewAlpha = 0.7
            self.opacityView.alpha = self.opacityViewAlpha
        }
    }
    
    @objc func confirmButtonTapped() {
        // 지역설정 버튼 타이틀 업데이트
        updateLocationButtonTitle()
        print("확인 버튼 탭탭\(self.selectedCity)\(self.selectedTown)")
        sendDataBackToMatchingViewController()
        // 필터링된 데이터로 Collection View를 다시 로드
        removeAllMarkers()
//        fetchPlacesWithKeywords()
        fetchPlacesWithKeywords(city: selectedCity, town: selectedTown)
    }
    
    private func updateLocationButtonTitle(){
        // 피커뷰에서 선택된 값을 가져오기
        let selectedCityRow = pickerView.pickerView.selectedRow(inComponent: 0)
        let selectedTownRow = pickerView.pickerView.selectedRow(inComponent: 1)
        
        // 'selectedCityIndex'를 첫 번째 열(시)에서 선택한 값으로 설정
        selectedCityIndex = selectedCityRow
        
        // 'selectedTownIndex'를 두 번째 열(구)에서 선택한 값으로 설정
        selectedTownIndex = selectedTownRow
        
        // 클래스 수준의 속성인 selectedCity와 selectedTown을 사용합니다.
        self.selectedCity = cities[selectedCityIndex]
        self.selectedTown = selectedCityIndex == 0 ? seoulTowns[selectedTownIndex] : incheonTowns[selectedTownIndex]
        
        // setLocationButton의 타이틀 업데이트
        searchMapUIView.matchingView.setLocationButton.setTitle("\(self.selectedCity ?? "지역") \(self.selectedTown ?? "미설정")", for: .normal)
        
        // PickerView 숨기기
        pickerView.removeFromSuperview()
        
        // 뒷배경 흐리게 해제
        setOpacityView()
    }
    
    private func setOpacityView(){
        // 피커뷰가 올라올 때 뒷배경에 들어갈 검은 화면임니두
        UIView.animate(withDuration: 0.3) {
            self.opacityViewAlpha = 0.0
            self.opacityView.alpha = self.opacityViewAlpha
        }
    }
    
    // 피커뷰 속성 설정
    private func setPickerViewAttribute(){
        // 피커뷰 서브뷰 설정
        view.addSubview(pickerView)
        pickerView.backgroundColor = .white
        
        // 피커뷰 델리게이트 설정
        pickerView.pickerView.delegate = self
        pickerView.pickerView.dataSource = self
        
        // 피커뷰 모서리 둥글게
        pickerView.layer.cornerRadius = 15
        pickerView.layer.masksToBounds = true
        
        // 피커뷰 레이아웃
        pickerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(500)
        }
    }
    // 피커뷰 외 터치 시 피커뷰 숨기기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: view)
            let convertedTouchLocation = pickerView.convert(touchLocation, from: view)
            
            if !pickerView.bounds.contains(convertedTouchLocation) {
                pickerView.removeFromSuperview()
                setOpacityView()
            }
        }
    }
    
}

extension SearchMapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            // 첫 번째 열에서 "시"의 개수 반환
            return cities.count
            
        } else if component == 1 {
            // 두 번째 열에서 "구"의 개수 :: 선택된 "시"에 따라 배열 반환
            if selectedCityIndex == 0 {
                return seoulTowns.count
            } else if selectedCityIndex == 1 {
                return incheonTowns.count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            // 첫 번째 열에서 "시" 설정
            return cities[row]
            
        } else if component == 1 {
            // 두 번째 열에서 "구" 설정 ::  선택된 "시"에 따라 배열 반환
            if selectedCityIndex == 0 {
                return seoulTowns[row]
                
            } else if selectedCityIndex == 1 {
                return incheonTowns[row]
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // 첫 번째 열(시)에서 선택한 경우 선택한 "시"의 인덱스를 업데이트
            selectedCityIndex = row
            
            // 두 번째 열(구)의 데이터도 업데이트 :: 두 번째 열 다시 로드
            pickerView.reloadComponent(1)
            
            // 선택한 "시"에 따라 기본적으로 첫 번째 "구"를 선택하게
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
}
