//
//  SearchViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit
import Then


class MatchingVC: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        configureUI()
       
    }
    
    
    // MARK: - Settings
    
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
    
    private func setCollectionViewAttribute(){
        collectionView.collectionView.delegate = self
        collectionView.collectionView.dataSource = self
    }
    
    private func setKeywordView(){
        matchingView.withKeywordButton.addTarget(self, action: #selector(firstKeywordButtonTapped), for: .touchUpInside)
        matchingView.conditionKeywordButton.addTarget(self, action: #selector(secondKeywordButtonTapped), for: .touchUpInside)
        matchingView.menuKeywordButton.addTarget(self, action: #selector(menuKeywordButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - Properties
   
    var updateWithMatchingKeywords: [String] = []
    var updateConditionMatchingKeywords: [String] = []
    var updateMenuMatchingKeywords: [String] = []
    
    private let matchingView = MatchingView()
    
    private let collectionView = MatchingResultCollectionView()
    
    private let keywordVC = MatchingKeywordVC()

    private let opacityView = OpacityView()
    
    private var opacityViewAlpha: CGFloat = 1.0 // 1.0은 완전 불투명, 0.0은 완전 투명

    private let pickerView = MatchingLocationPickerView()
    
    
    //dummy location
    private let selectedCity: [String] = ["서울"]
    
    private let selectedTown: [String] = ["전체","강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구",
                                          "도봉구","동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구",
                                          "송파구", "양천구", "영등포구","용산구", "은평구", "종로구", "중구", "중랑구"]
    
    private var selectedCityIndex: Int = 0
    
    private var selectedTownIndex: Int = 0
    
    
    // MARK: - Actions
    
    @objc private func mapButtonTapped() {
        print("지도 버튼 탭")
        let mapViewController = SearchMapViewController()
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
    @objc func firstKeywordButtonTapped() {
        print("첫 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .with
        keywordVC.noticeLabel.text = "누구랑\n가시나요?"
        keywordVC.userChoiceCollectionView.reloadData()  // 첫 번째 키워드로 컬렉션 뷰 로드
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 두 번째 키워드 버튼이 탭될 때
    @objc func secondKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .condition
        keywordVC.noticeLabel.text = "어떤 분위기를\n원하시나요?"
        keywordVC.userChoiceCollectionView.reloadData() // 두 번째 키워드로 컬렉션 뷰 로드
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 메뉴 키워드 버튼이 탭될 때
    @objc func menuKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .menu
        keywordVC.noticeLabel.text = "메뉴는\n무엇인가요?"
        keywordVC.userChoiceCollectionView.reloadData() // 메뉴 키워드로 컬렉션 뷰 로드
        keywordVC.delegate = self
        
        navigationController?.present(keywordVC, animated: true)
    }
    
    @objc func confirmButtonTapped() {
        // 피커뷰에서 선택된 값을 가져오기
        let selectedCityRow = pickerView.pickerView.selectedRow(inComponent: 0)
        let selectedTownRow = pickerView.pickerView.selectedRow(inComponent: 1)
        
        let selectedCity = selectedCity[selectedCityRow]
        let selectedTown = selectedTown[selectedTownRow]
        
        // setLocationButton의 타이틀 업데이트
        matchingView.setLocationButton.setTitle("\(selectedCity) \(selectedTown)", for: .normal)
        
        // PickerView 숨기기
        pickerView.removeFromSuperview()
        
        // 탭바 다시 보이게 하기
        tabBarController?.tabBar.isHidden = false
        
        // 뒷배경 흐리게 해제
        setOpacityView()
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
}



//MARK: - MatchingVC Delegate

extension MatchingVC: MatchingKeywordDelegate {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType) {
        let keywordType = keywordType
        
        print(keywordType)
        
        switch keywordType {
        case .with:
            if let updateKeyword = keyword.first {
                matchingView.withKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.withKeywordButton.setTitleColor(.darkGray, for: .normal)
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                matchingView.conditionKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.conditionKeywordButton.setTitleColor(.darkGray, for: .normal)
            }
            
        case .menu:
            if let updateKeyword = keyword.first {
                matchingView.menuKeywordButton.setTitle(updateKeyword, for: .normal)
                matchingView.menuKeywordButton.setTitleColor(.darkGray, for: .normal)
            }
        }
    }
}


//MARK: - CollectionView Delegate, DataSource, Layout

extension MatchingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 25, height: collectionView.frame.width / 2 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //                return recommendItems.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingSearchResultCell.identifier ,for: indexPath) as? MatchingSearchResultCell else {
            return UICollectionViewCell()
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
        print("매칭 업체 페이지로 이동합니다.")
        if collectionView.cellForItem(at: indexPath) is MatchingSearchResultCell {
            let matchingVC = MatchingPlaceVC()
            self.navigationController?.pushViewController(matchingVC, animated: true)
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
            // City(시)의 개수 반환
            return selectedCity.count
        } else if component == 1 {
            // Town(구)의 개수 반환
            return selectedTown.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            // City(시) 설정
            return selectedCity[row]
        } else if component == 1 {
            // Town(구) 설정
            return selectedTown[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // City(시) 선택이 변경되었을 때
            selectedCityIndex = row
        } else if component == 1 {
            // Town(구) 선택이 변경되었을 때
            selectedTownIndex = row
        }
    }
}