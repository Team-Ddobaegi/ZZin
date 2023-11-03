
import UIKit
import SnapKit
import Then
import Firebase
import NMapsMap


class MatchingVC: UIViewController {
    
    //MARK: - Properties
    
    let dataManager = FireStoreManager()
    var place: [Place]?
    var review: [Review]?
    
    var companionKeyword : [String?]?
    var conditionKeyword : [String?]?
    var kindOfFoodKeyword : [String?]?
    var selectedCity : String?
    var selectedTown : String?
    var currentLocation: NMGLatLng?
    
    private let matchingView = MatchingView()
    private let keywordVC = MatchingKeywordVC()
    private let locationPickerVC = MatchingLocationPickerVC()
    private let resultCV = MatchingResultCollectionView()
 

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        configureUI()
        locationSetting()
        currentLocation = LocationService.shared.getCurrentLocation()
        getAddress()
        fetchPlacesWithKeywords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setKeywordButtonTitle()
    }
    
    
    
    // MARK: - Settings
   
    private func setView(){
        view.backgroundColor = .white
        setMapView()
        setlocationView()
        setPickerView()
        setCollectionViewAttribute()
        setKeywordView()
    }
    
    private func setMapView(){
        matchingView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    private func setlocationView(){
        matchingView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func setPickerView(){
        matchingView.setLocationButton.addTarget(self, action: #selector(setPickerViewTapped), for: .touchUpInside)
    }
    
    private func configureSheetPresentation(_ sheet: UISheetPresentationController) {
        sheet.preferredCornerRadius = 15
        sheet.prefersGrabberVisible = true

        if #available(iOS 16.0, *) {
            sheet.detents = [.custom { $0.maximumDetentValue * 0.65 }]
        }
        sheet.largestUndimmedDetentIdentifier = .large
    }

    private func setCollectionViewAttribute(){
        resultCV.collectionView.delegate = self
        resultCV.collectionView.dataSource = self
    }
    
    func fetchPlacesWithKeywords(companion: String? = nil, condition: String? = nil, kindOfFood: String? = nil, city: String? = nil, town: String? = nil) {
        let actualCompanion = companion ?? self.companionKeyword?.first ?? nil
        let actualCondition = condition ?? self.conditionKeyword?.first ?? nil
        let actualKindOfFood = kindOfFood ?? self.kindOfFoodKeyword?.first ?? nil
        let actualCity = city ?? self.selectedCity ?? nil
        let actualTown = town ?? self.selectedTown
        FireStoreManager().fetchPlacesWithKeywords(companion: actualCompanion, condition: actualCondition, kindOfFood: actualKindOfFood, city: actualCity, town: actualTown) { result in
            switch result {
            case .success(let places):
                self.place = places
                print("~~피커뷰 선택값 전달받았읍니두~~","\(self.selectedCity ?? "지역") \(self.selectedTown ?? "미설정")")
                print("~~플레이스 카운트~~", self.place?.count ?? "")

                DispatchQueue.main.async {
                    self.resultCV.collectionView.reloadData()
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func locationSetting() {
        LocationService.shared.delegate = self
    }
    
    func getAddress() {
        self.currentLocation = LocationService.shared.getCurrentLocation()
        LocationService.shared.getAddressFromLocation(lat: self.currentLocation?.lat ?? 0, lng: self.currentLocation?.lng ?? 0) { (address, error) in
            if let error = error {
                print("Error getting address: \(error.localizedDescription)")
                return
            }
            if let address = address {
                print("Current address: \(address)")
                
                if let city = address.first, city.count >= 2 {
                    self.locationPickerVC.selectedCity = String(city.prefix(2))
                }
                self.locationPickerVC.selectedTown = address.last
                print("@@@@@@@ \(self.locationPickerVC.selectedCity),\(self.locationPickerVC.selectedTown)")
            } else {
                print("Address not found.")
            }
        }
    }
  
    
    // MARK: - Actions
    
    @objc private func mapButtonTapped() {
        print("지도 버튼 탭")
        let mapViewController = SearchMapViewController()
        mapViewController.companionKeyword = companionKeyword
        mapViewController.conditionKeyword = conditionKeyword
        mapViewController.kindOfFoodKeyword = kindOfFoodKeyword
        mapViewController.selectedCity = locationPickerVC.selectedCity
        mapViewController.selectedTown = locationPickerVC.selectedTown
        mapViewController.mapViewDelegate = self
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @objc private func locationButtonTapped() {
        print("현재 위치 버튼 탭")
        getAddress()
    }
    
    @objc private func setPickerViewTapped() {
        print("위치 설정 피커뷰 탭")
        
        let pickerViewVC = MatchingLocationPickerVC()
        pickerViewVC.pickerViewDelegate = self
        
        if let sheet = pickerViewVC.sheetPresentationController {
            configureSheetPresentation(sheet)
        }
        present(pickerViewVC, animated: true)
    }
    
    @objc func companionKeywordButtonTapped() {
        print("첫 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .companion
        keywordVC.matchingKeywordView.noticeLabel.text = "누구랑\n가시나요?"
        keywordVC.delegate = self
        
        present(keywordVC, animated: true)
    }
    
    @objc func conditionKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .condition
        keywordVC.matchingKeywordView.noticeLabel.text = "어떤 분위기를\n원하시나요?"
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    @objc func kindOfFoodKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .kindOfFood
        keywordVC.matchingKeywordView.noticeLabel.text = "메뉴는\n무엇인가요?"
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    
    
    //MARK: - Configure UI
    
    private func configureUI(){
        addSubViews()
        setSearchViewConstraints()
        setCollectionViewConstraints()
    }
    
    private func addSubViews(){
        view.addSubview(matchingView)
        view.addSubview(resultCV)
    }
    
    private func setSearchViewConstraints(){
        matchingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(232)
        }
    }
    
    private func setCollectionViewConstraints(){
        resultCV.snp.makeConstraints {
            $0.top.equalTo(matchingView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-90)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func setKeywordView(){
        matchingView.companionKeywordButton.addTarget(self, action: #selector(companionKeywordButtonTapped), for: .touchUpInside)
        matchingView.conditionKeywordButton.addTarget(self, action: #selector(conditionKeywordButtonTapped), for: .touchUpInside)
        matchingView.kindOfFoodKeywordButton.addTarget(self, action: #selector(kindOfFoodKeywordButtonTapped), for: .touchUpInside)
    }
    
    func setKeywordButtonTitle() {
        let firstCompanionKeyword = companionKeyword?.first ?? nil ?? nil
        matchingView.companionKeywordButton.setTitle(firstCompanionKeyword ?? "키워드", for: .normal)
        matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
        
        let firstConditionKeyword = conditionKeyword?.first ?? nil ?? nil
        matchingView.conditionKeywordButton.setTitle(firstConditionKeyword ?? "키워드", for: .normal)
        matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
        
        let firstKindOfFoodKeyword = kindOfFoodKeyword?.first ?? nil ?? nil
        matchingView.kindOfFoodKeywordButton.setTitle(firstKindOfFoodKeyword ?? "키워드", for: .normal)
        matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
    }
    
}



//MARK: - CollectionView Delegate, DataSource, Layout


extension MatchingVC: UICollectionViewDelegateFlowLayout {
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 28, height: collectionView.frame.width / 2 + 40)
    }
}


extension MatchingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 등록된 플레이스 개수만큼 컬렉션뷰셀 반환
        return place?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingResultCell.identifier ,for: indexPath) as? MatchingResultCell else {
            return UICollectionViewCell()
        }

        // 플레이스에 등록된 플레이스 네임을 컬렉션뷰 셀의 제목에 반환
        if let placeData = place {
            let placeName = placeData[indexPath.item].placeName
            cell.recommendPlaceReview.titleLabel.text = placeName
          
            let placeImg = place?[indexPath.item].placeImg[0]
            FireStorageManager().bindPlaceImgWithPath(path: placeImg, imageView: cell.recommendPlaceReview.img)
            
            let placeTown = place?[indexPath.item].town
            cell.recommendPlaceReview.placeTownLabel.text = placeTown
            
            let placeMenu = place?[indexPath.item].kindOfFood
            cell.recommendPlaceReview.placeMenuLabel.text = placeMenu
        }
        
        return cell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 양 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.cellForItem(at: indexPath) is MatchingResultCell {
            print("매칭 업체 페이지로 이동합니다.")

            let matchingPlaceVC = MatchingPlaceVC()
            self.navigationController?.pushViewController(matchingPlaceVC, animated: true)
            
            matchingPlaceVC.placeID = place?[indexPath.item].pid
            matchingPlaceVC.reviewID = place?[indexPath.item].rid
        }
    }
}


//MARK: - Matching Keyword Delegate

extension MatchingVC: LocationPickerViewDelegate {
    func updateLocation(city: String?, town: String?) {
        let selectedCity = city
        let selectedTown = town
        
        // 피커뷰에서 선택된 지역으로 타이틀 업데이트
        matchingView.setLocationButton.setTitle("\(selectedCity ?? "") \(selectedTown ?? "")", for: .normal)
        self.selectedCity = selectedCity
        self.selectedTown = selectedTown
        
        // 선택 지역으로 컬렉션뷰 리로드
        fetchPlacesWithKeywords()
    }
}


//MARK: - Matching Keyword Delegate


extension MatchingVC: MatchingKeywordDelegate {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType) {
        let keywordType = keywordType
        
            switch keywordType {
            case .companion:
                if let updateKeyword = keyword.first {
                    matchingView.companionKeywordButton.setTitle(updateKeyword, for: .normal)
                    matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
                    self.companionKeyword = keyword
                }
                
            case .condition:
                if let updateKeyword = keyword.first {
                    matchingView.conditionKeywordButton.setTitle(updateKeyword, for: .normal)
                    matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
                    self.conditionKeyword = keyword
                }
                
            case .kindOfFood:
                if let updateKeyword = keyword.first {
                    matchingView.kindOfFoodKeywordButton.setTitle(updateKeyword, for: .normal)
                    matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
                    self.kindOfFoodKeyword = keyword
                }
        }
        fetchPlacesWithKeywords()
    }
}



// MARK: - SearchMapVC Delegate

extension MatchingVC: SearchMapViewControllerDelegate {
    func didUpdateSearchData(companionKeyword: [String?]?, conditionKeyword: [String?]?, kindOfFoodKeyword: [String?]?, selectedCity: String?, selectedTown: String?) {
        self.companionKeyword = companionKeyword
        self.conditionKeyword = conditionKeyword
        self.kindOfFoodKeyword = kindOfFoodKeyword
        self.selectedCity = selectedCity
        self.selectedTown = selectedTown
    }
}

extension MatchingVC: LocationServiceDelegate {
    func didUpdateLocation(lat: Double, lng: Double) {
        print("\(lat)")
    }
    
    func didFailWithError(error: Error) {
        print("\(error)")
    }
}
