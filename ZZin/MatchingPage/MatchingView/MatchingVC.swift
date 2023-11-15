
import UIKit
import SnapKit
import Then
import Firebase
import NMapsMap


class MatchingVC: UIViewController {
    
    //MARK: - Properties
    
    var place: [Place]?
    var review: [Review]?
    
    private var selectedCity : String?
    private var selectedTown : String?
    
    var companionKeyword : [String?]? = []
    var conditionKeyword : [String?]? = []
    var kindOfFoodKeyword : [String?]? = []
    
    var companionIndexPath: [IndexPath?]? = []
    var conditionIndexPath: [IndexPath?]? = []
    var kindOfFoodIndexPath: [IndexPath?]? = []
    
    var currentLocation: NMGLatLng?
    
    private let matchingView = MatchingView()
    private let resultCV = MatchingResultCollectionView()
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        configureUI()
        locationSetting()
        currentLocation = LocationService.shared.getCurrentLocation()
//        getAddress()
        matchingView.resetFilterButton.isEnabled = false
        updateResetButtonStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setKeywordButtonTitle()
        setLocationTitle()
        fetchPlacesWithKeywords()
        updateResetButtonStatus()
    }
    
    
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .customBackground
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
        resultCV.collectionView.showsVerticalScrollIndicator = false
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
                print("\(self.selectedCity ?? "지역") \(self.selectedTown ?? "미설정") ")
                print(self.place?.count ?? "")
                
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
                    self.selectedCity = String(city.prefix(2))
                }
                self.selectedTown = address.last
                self.matchingView.setLocationButton.setTitle("\(self.selectedCity ?? "") \(self.selectedTown ?? "")", for: .normal)
                print("@@@@@@@ \(self.selectedCity),\(self.selectedTown)")
                self.fetchPlacesWithKeywords()
                
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
        mapViewController.companionIndexPath = companionIndexPath
        mapViewController.conditionIndexPath = conditionIndexPath
        mapViewController.kindOfFoodIndexPath = kindOfFoodIndexPath
        mapViewController.mapViewDelegate = self
        mapViewController.selectedCity = selectedCity
        mapViewController.selectedTown = selectedTown
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
    
    @objc func resetFilterButtonTapped() {
        companionKeyword = []
        conditionKeyword = []
        kindOfFoodKeyword = []
        companionIndexPath = []
        conditionIndexPath = []
        kindOfFoodIndexPath = []
        
        matchingView.companionKeywordButton.setTitle("키워드", for: .normal)
        matchingView.conditionKeywordButton.setTitle("키워드", for: .normal)
        matchingView.kindOfFoodKeywordButton.setTitle("키워드", for: .normal)
        
        fetchPlacesWithKeywords()
        updateResetButtonStatus()
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
        matchingView.resetFilterButton.addTarget(self, action: #selector(resetFilterButtonTapped), for: .touchUpInside)
    }
    
    private func setLocationTitle() {
        matchingView.setLocationButton.setTitle("\(selectedCity ?? "지역") \(selectedTown ?? "미설정")", for: .normal)
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
    
    func updateResetButtonStatus() {
        if companionKeyword == [] && conditionKeyword == [] && kindOfFoodKeyword == [] {
            matchingView.resetFilterButton.isEnabled = false
            matchingView.resetFilterButton.layer.borderColor = UIColor.systemGray.cgColor
        } else {
            matchingView.resetFilterButton.isEnabled = true
            matchingView.resetFilterButton.layer.borderColor = ColorGuide.main.cgColor
        }
    }
    
}



//MARK: - CollectionView Delegate, DataSource, Layout


extension MatchingVC: UICollectionViewDelegateFlowLayout {
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 20, height: collectionView.frame.width / 2 - 10)
    }
}


extension MatchingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
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
        self.selectedCity = selectedCity
        self.selectedTown = selectedTown
        matchingView.setLocationButton.setTitle("\(selectedCity ?? "") \(selectedTown ?? "")", for: .normal)

        // 선택 지역으로 컬렉션뷰 리로드
        fetchPlacesWithKeywords()
    }
}


//MARK: - Matching Keyword Delegate


extension MatchingVC: MatchingKeywordDelegate {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType, indexPath: [IndexPath]) {
        
        switch keywordType {
        case .companion:
            if let updateKeyword = keyword.first {
                matchingView.companionKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.companionKeyword = [updateKeyword as String?]
                self.companionIndexPath = indexPath
                //                print("~~ companion 인덱스 전달 받았음두", indexPath)
                
            } else if indexPath.isEmpty {
                self.companionIndexPath = []
                self.conditionKeyword = []
                print("~~ companion 인덱스는 없어!", self.companionIndexPath as Any)
                
                matchingView.companionKeywordButton.setTitle("키워드", for: .normal)
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                matchingView.conditionKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.conditionKeyword = [updateKeyword as String?]
                self.conditionIndexPath = indexPath
                //                print("~~ condition 인덱스 전달 받았음두", indexPath)
                
            } else if indexPath.isEmpty {
                self.conditionIndexPath = []
                self.conditionKeyword = []
                matchingView.conditionKeywordButton.setTitle("키워드", for: .normal)
                print("~~ condition 인덱스는 없어!", self.conditionIndexPath as Any)
                
            }
            
        case .kindOfFood:
            if let updateKeyword = keyword.first {
                matchingView.kindOfFoodKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.kindOfFoodKeyword = [updateKeyword as String?]
                self.kindOfFoodIndexPath = indexPath
                //                print("~~ kindOfFood 인덱스 전달 받았음두", indexPath)
                
            } else if indexPath.isEmpty {
                self.kindOfFoodIndexPath = []
                self.kindOfFoodKeyword = []
                matchingView.kindOfFoodKeywordButton.setTitle("키워드", for: .normal)
                print("~~ kindOfFood 인덱스는 없어!", self.kindOfFoodIndexPath as Any)
            }
        }
        
        fetchPlacesWithKeywords()
        updateResetButtonStatus()
    }
}



// MARK: - SearchMapVC Delegate

extension MatchingVC: SearchMapViewControllerDelegate {
    func didUpdateSearchData(companionKeyword: [String?]?, conditionKeyword: [String?]?, kindOfFoodKeyword: [String?]?, companionIndexPath: [IndexPath?]?, conditionIndexPath: [IndexPath?]?, kindOfFoodIndexPath: [IndexPath?]?, selectedCity: String?, selectedTown: String?) {
        self.companionKeyword = companionKeyword
        self.conditionKeyword = conditionKeyword
        self.kindOfFoodKeyword = kindOfFoodKeyword
        self.companionIndexPath = companionIndexPath
        self.conditionIndexPath = conditionIndexPath
        self.kindOfFoodIndexPath = kindOfFoodIndexPath
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
