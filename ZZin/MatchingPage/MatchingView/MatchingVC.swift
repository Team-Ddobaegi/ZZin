//
//  SearchViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit
import Then
import Firebase


class MatchingVC: UIViewController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDataManager()
        setView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setKeywordButtonTitle()
    }
    
    
    // MARK: - Settings
    
    func setDataManager(){
        // 플레이스 데이터 불러오기
        dataManager.getPlaceData { [weak self] result in
            if let placeData = result {
                self?.place = placeData
                self?.collectionView.collectionView.reloadData()
            }
        }
    }
    
    private func setView(){
        view.backgroundColor = .white
        
        setMapView()
        setlocationView()
        setOpacityView()
        setPickerView()
        setCollectionViewAttribute()
        setKeywordView()
        configureUI()
    }
    
    private func setMapView(){
        matchingView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    private func setlocationView(){
        matchingView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func setOpacityView(){
        // 피커뷰가 올라올 때 뒷배경에 들어갈 검은 화면임니두
        UIView.animate(withDuration: 0.3) {
            self.opacityViewAlpha = 0.0
            self.opacityView.alpha = self.opacityViewAlpha
        }
    }
    
    // 지역 설정 피커뷰
    private func setPickerView(){
        matchingView.setLocationButton.addTarget(self, action: #selector(setPickerViewTapped), for: .touchUpInside)
        pickerView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
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
    
    // 피커뷰에서 설정한 값 > MatchingView - setLocationButton의 Title 업데이트하는 메서드입니두
    private func updateLocationButtonTitle(){
        // 피커뷰에서 선택된 값을 가져오기
        let selectedCityRow = pickerView.pickerView.selectedRow(inComponent: 0)
        let selectedTownRow = pickerView.pickerView.selectedRow(inComponent: 1)
        
        // 'selectedCityIndex'를 첫 번째 열(시)에서 선택한 값으로 설정
        selectedCityIndex = selectedCityRow
        
        // 'selectedTownIndex'를 두 번째 열(구)에서 선택한 값으로 설정
        selectedTownIndex = selectedTownRow
        
        // 클래스 수준의 속성인 selectedCity와 selectedTown을 사용합니다.
        let selectedCity = cities[selectedCityIndex]
        let selectedTown = selectedCityIndex == 0 ? seoulTowns[selectedTownIndex] : incheonTowns[selectedTownIndex]
        
        // setLocationButton의 타이틀 업데이트
        matchingView.setLocationButton.setTitle("\(selectedCity) \(selectedTown)", for: .normal)
        
        // PickerView 숨기기
        pickerView.removeFromSuperview()
        
        // 뒷배경 흐리게 해제
        setOpacityView()
    }
    
    private func setCollectionViewAttribute(){
        collectionView.collectionView.delegate = self
        collectionView.collectionView.dataSource = self
    }
    
    private func setKeywordView(){
        matchingView.companionKeywordButton.addTarget(self, action: #selector(companionKeywordButtonTapped), for: .touchUpInside)
        matchingView.conditionKeywordButton.addTarget(self, action: #selector(conditionKeywordButtonTapped), for: .touchUpInside)
        matchingView.kindOfFoodKeywordButton.addTarget(self, action: #selector(kindOfFoodKeywordButtonTapped), for: .touchUpInside)
    }
    
    // 피커뷰 외 터치 시 피커뷰 숨기기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: view)
            let convertedTouchLocation = pickerView.convert(touchLocation, from: view)
            
            if !pickerView.bounds.contains(convertedTouchLocation) {
                pickerView.removeFromSuperview()
                tabBarController?.tabBar.isHidden = false
                setOpacityView()
            }
        }
    }
    
    // 지역 설정 필터링 메서드
    func filterLocationData() {
        // 피커뷰에서 선택된 시와 구의 값을 가져옴
        let selectedCity = cities[selectedCityIndex]
        let selectedTown = selectedCityIndex == 0 ? seoulTowns[selectedTownIndex] : incheonTowns[selectedTownIndex]
        
        // Firestore에서 모든 플레이스 데이터를 가져옵니다.
        dataManager.getPlaceData { [weak self] result in
            if let placeData = result {
                var filteredPlaces: [Place] = []
                
                if selectedTown == "전체" {
                    // "구"가 "전체"로 선택된 경우, "시"에 따라 모든 데이터를 가져옵니다.
                    filteredPlaces = placeData.filter { place in
                        return place.city == selectedCity
                    }
                } else {
                    // "시"와 "구" 모두 선택된 경우, 선택한 "시"와 "구"와 일치하는 데이터만 필터링합니다.
                    filteredPlaces = placeData.filter { place in
                        return place.city == selectedCity && place.town == selectedTown
                    }
                }
                
                // 필터링된 데이터로 Collection View를 다시 로드합니다.
                self?.place = filteredPlaces
                self?.collectionView.collectionView.reloadData()
            }
        }
    }

    func filterKeywordData() {
        let companionKeyword = matchingView.companionKeywordButton.titleLabel?.text ?? ""
        let conditionKeyword = matchingView.conditionKeywordButton.titleLabel?.text ?? ""
        let kindOfFoodKeyword = matchingView.kindOfFoodKeywordButton.titleLabel?.text ?? ""
        
        print("Companion: \(companionKeyword), Condition: \(conditionKeyword), KindOfFood: \(kindOfFoodKeyword)")
                
        if let reviewIDs = review?.compactMap({ $0.rid }) {
            for rid in reviewIDs {
                FireStoreManager.shared.fetchDataWithRid(rid: rid) { result in
                    switch result {
                    case .success(let review):
                        let companion = review.companion
                        let condition = review.condition
                        let kindOfFood = review.kindOfFood
                        
                        print("-------- Review \(rid): Companion: \(companion), Condition: \(condition), KindOfFood: \(kindOfFood)")

                        // Companion, Condition, KindOfFood 값이 일치하는 경우 리뷰를 선택
//                        if companion == companionKeyword && condition == conditionKeyword && kindOfFood == kindOfFoodKeyword {
//                            matchingReviews.append(review)
//                        }

                    case .failure(let error):
                        print("Error fetching review: \(error.localizedDescription)")
                    }
                }
            }
        }
//        print("Matching Reviews Count: \(matchingReviews.count)")

        collectionView.collectionView.reloadData()
    }
    
    
    
    //MARK: - Properties
    
    // FirestoreManager
    let dataManager = FireStoreManager()
    var place: [Place]?
    var review: [Review]?
    var selectedCity: String?
    var selectedTown: String?
    
//    var companionKeyword: String?
//    
//    var conditionKeyword: String?
//    
//    var kindOfFoodKeyword: String?

    
    // 업데이트된 키워드를 저장하는 배열입니두
    var updateWithMatchingKeywords: [String?]?
    var updateConditionMatchingKeywords: [String?]?
    var updateMenuMatchingKeywords: [String?]?
    
    
    private let matchingView = MatchingView()
    
    private let collectionView = MatchingResultCollectionView()
    
    private let keywordVC = MatchingKeywordVC()
    
    private let opacityView = OpacityView()
    
    private var opacityViewAlpha: CGFloat = 1.0 // 1.0은 완전 불투명, 0.0은 완전 투명
    
    private let pickerView = MatchingLocationPickerView()
    
    
    // 선택된 "시"의 인덱스
    private var selectedCityIndex: Int = 0
    // 피커뷰 1열에 들어갈 "시"
    private let cities = ["서울", "인천"] // "시"에 대한 데이터 배열
    
    
    // 선택된 "구"의 인덱스
    private var selectedTownIndex: Int = 0
    // 피커뷰 2열에 들어갈 "구"
    private let seoulTowns = ["전체", "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구"]
    private let incheonTowns = ["전체", "부평구", "연수구", "미추홀구"]
    
    
    //    //dummy location
    //    private let selectedCity: [String] = ["지역", "서울", "인천"]
    //    private let selectedTown: [String] = ["전체","강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구"]
    ////    ,"도봉구","동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구",
    ////    "송파구", "양천구", "영등포구","용산구", "은평구", "종로구", "중구", "중랑구"]
    //    private let selectedIncheonTown: [String] = ["전체", "중구", "동구", "남구"]
    
    
    
    
    // MARK: - Actions
    

    
    @objc private func mapButtonTapped() {
        print("지도 버튼 탭")
        let mapViewController = SearchMapViewController()
        mapViewController.companionKeyword = updateWithMatchingKeywords
        mapViewController.conditionKeyword = updateConditionMatchingKeywords
        mapViewController.kindOfFoodKeyword = updateMenuMatchingKeywords
        mapViewController.selectedCity = selectedCity
        mapViewController.selectedTown = selectedTown
        mapViewController.mapViewDelegate = self
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @objc private func locationButtonTapped() {
        print("현재 위치 버튼 탭")
    }
    
    @objc private func setPickerViewTapped() {
        print("지역 설정 피커뷰 탭")
        setPickerViewAttribute()
        
        UIView.animate(withDuration: 0.1) {
            self.opacityViewAlpha = 0.7
            self.opacityView.alpha = self.opacityViewAlpha
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    // 첫 번째 키워드 버튼이 탭될 때
    @objc func companionKeywordButtonTapped() {
        print("첫 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .with
        keywordVC.noticeLabel.text = "누구랑\n가시나요?"
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 두 번째 키워드 버튼이 탭될 때
    @objc func conditionKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .condition
        keywordVC.noticeLabel.text = "어떤 분위기를\n원하시나요?"
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 메뉴 키워드 버튼이 탭될 때
    @objc func kindOfFoodKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .menu
        keywordVC.noticeLabel.text = "메뉴는\n무엇인가요?"
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    @objc func confirmButtonTapped() {
        // 탭바 다시 보이게 하기
        tabBarController?.tabBar.isHidden = false
        
        // 지역설정 버튼 타이틀 업데이트
        updateLocationButtonTitle()
        
        // 필터링된 데이터로 Collection View를 다시 로드
        filterLocationData()
        collectionView.collectionView.reloadData()
    }
    
    
    
    //MARK: - Configure UI
    
    private func configureUI(){
        addSubViews()
        setSearchViewConstraints()
        setCollectionViewConstraints()
        setOpacityViewConstraints()
    }
    
    private func addSubViews(){
        view.addSubview(matchingView)
        view.addSubview(collectionView)
        view.addSubview(opacityView)
    }
    
    private func setSearchViewConstraints(){
        matchingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(232)
            
        }
    }
    
    private func setCollectionViewConstraints(){
        collectionView.snp.makeConstraints {
            $0.top.equalTo(matchingView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-90)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func setOpacityViewConstraints(){
        opacityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    

    func setKeywordButtonTitle() {
        let firstCompanionKeyword = updateWithMatchingKeywords?.first ?? nil ?? nil
        matchingView.companionKeywordButton.setTitle(firstCompanionKeyword ?? "키워드", for: .normal)
        matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
        
        let firstConditionKeyword = updateConditionMatchingKeywords?.first ?? nil ?? nil
        matchingView.conditionKeywordButton.setTitle(firstConditionKeyword ?? "키워드", for: .normal)
        matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
        
        let firstKindOfFoodKeyword = updateMenuMatchingKeywords?.first ?? nil ?? nil
        matchingView.kindOfFoodKeywordButton.setTitle(firstKindOfFoodKeyword ?? "키워드", for: .normal)
        matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
    }
    
}

//MARK: - MatchingVC Delegate

extension MatchingVC: MatchingKeywordDelegate {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType) {
        let keywordType = keywordType
        
        switch keywordType {
        case .with:
            if let updateKeyword = keyword.first {
                matchingView.companionKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.companionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.updateWithMatchingKeywords = keyword
                print("!!!!!!!!!!\(keyword)")
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                matchingView.conditionKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.updateConditionMatchingKeywords = keyword
            }
            
        case .menu:
            if let updateKeyword = keyword.first {
                matchingView.kindOfFoodKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.kindOfFoodKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.updateMenuMatchingKeywords = keyword
            }
        }
    }
}




//MARK: - CollectionView Delegate, DataSource, Layout

extension MatchingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 28, height: collectionView.frame.width / 2 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 등록된 플레이스 개수만큼 컬렉션뷰셀 반환
        return place?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingSearchResultCell.identifier ,for: indexPath) as? MatchingSearchResultCell else {
            return UICollectionViewCell()
        }
        
        // 플레이스에 등록된 플레이스 네임을 컬렉션뷰 셀의 제목에 반환
        if let placeData = place {
            let placeName = placeData[indexPath.item].placeName
            cell.recommendPlaceReview.titleLabel.text = placeName
        }
        
        let reviewID = place?[indexPath.item].rid[0] ?? "타이틀"
        
        FireStoreManager.shared.fetchDataWithRid(rid: reviewID) { (result) in
            switch result {
            case .success(let review):
                cell.recommendPlaceReview.descriptionLabel.text = review.title
            case .failure(let error):
                print("Error fetching review: \(error.localizedDescription)")
            }
        }
        
//        // 리뷰에 등록된 타이틀 컬렉션뷰 셀 타이틀로 반환
//        let db = Firestore.firestore()
//        let reviewID = place?[indexPath.item].rid[0] ?? "타이틀"
//
//        db.collection("reviews").document(reviewID).getDocument { (document, error) in
//            if let error = error {
//                print("Error getting document: \(error)")
//            } else if let document = document, document.exists {
//                if let reviewData = document.data() {
//                    if let reviewTitle = reviewData["title"] as? String {
//                        cell.recommendPlaceReview.descriptionLabel.text = reviewTitle
//                    }
//                    // 여기에서 다른 필드에 액세스하거나 필요한 데이터 처리를 수행할 수 있습니다.
//                }
//            }
//        }
        
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
        print("매칭 업체 페이지로 이동합니다.")
        if collectionView.cellForItem(at: indexPath) is MatchingSearchResultCell {
            let matchingVC = MatchingPlaceVC()
            self.navigationController?.pushViewController(matchingVC, animated: true)
            
            matchingVC.placeID = place?[indexPath.item].pid
        }
    }
}



//MARK: - PickerView Delegate, DataSource

extension MatchingVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    // MARK: - 기존 피커뷰 코드입니두 ~~
    //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    //        if component == 0 {
    //            // City(시)의 개수 반환
    //            return selectedCity.count
    //        } else if component == 1 {
    //            // Town(구)의 개수 반환
    //            return selectedTown.count
    //        }
    //        return 0
    //    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        if component == 0 {
    //            // City(시) 설정
    //            return selectedCity[row]
    //        } else if component == 1 {
    //            // Town(구) 설정
    //            return selectedTown[row]
    //        }
    //        return nil
    //    }
    
    //
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //        if component == 0 {
    //            // City(시) 선택이 변경되었을 때
    //            selectedCityIndex = row
    //        } else if component == 1 {
    //            // Town(구) 선택이 변경되었을 때
    //            selectedTownIndex = row
    //        }
    //        // 선택한 값에 기반하여 데이터를 필터링합니다.
    //        filterData()
    //
    //        // 필터링된 데이터로 Collection View를 다시 로드합니다.
    //        collectionView.collectionView.reloadData()
    //    }
    //
    
}

extension MatchingVC: SearchMapViewControllerDelegate {
    func didUpdateSearchData(companionKeyword: [String?]?, conditionKeyword: [String?]?, kindOfFoodKeyword: [String?]?, selectedCity: String?, selectedTown: String?) {
        self.updateWithMatchingKeywords = companionKeyword
        self.updateConditionMatchingKeywords = conditionKeyword
        self.updateMenuMatchingKeywords = kindOfFoodKeyword
        self.selectedCity = selectedCity
        self.selectedTown = selectedTown
    }
}
