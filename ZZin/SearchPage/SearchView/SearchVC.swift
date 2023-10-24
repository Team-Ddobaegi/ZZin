//
//  SearchViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit
import Then

class SearchVC: UIViewController {
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        configureUI()
    }
    
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .white
        view.addSubview(searchView)
        view.addSubview(collectionView)
        view.addSubview(opacityView)
        
        setMapView()
        setlocationView()
        setOpacityView()
        setPickerView()
        setCollectionViewAttribute()
        setKeywordView()
    }
    
    private func setMapView(){
        searchView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    private func setlocationView(){
        searchView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func setOpacityView(){
        UIView.animate(withDuration: 0.3) {
            self.opacityViewAlpha = 0.0
            self.opacityView.alpha = self.opacityViewAlpha
        }
    }
    
    // 지역 설정 피커뷰
    private func setPickerView(){
        searchView.setLocationButton.addTarget(self, action: #selector(setPickerViewTapped), for: .touchUpInside)
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
        searchView.firstKeywordButton.addTarget(self, action: #selector(keywordButtonTapped), for: .touchUpInside)
        searchView.secondKeywordButton.addTarget(self, action: #selector(keywordButtonTapped), for: .touchUpInside)
        searchView.menuKeywordButton.addTarget(self, action: #selector(keywordButtonTapped), for: .touchUpInside)
    }
    
    
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
    private let collectionView = SearchResultCollectionView()
    
    private let opacityView = OpacityView()
    
    private var opacityViewAlpha: CGFloat = 1.0 // 1.0은 완전 불투명, 0.0은 완전 투명

    private let pickerView = LocationPickerView()
    
    
    //dummy location
    private let selectedCity: [String] = ["서울"]
    
    private let selectedTown: [String] = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구",
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
    
    @objc private func keywordButtonTapped() {
        print("keywordButtonTapped")
        let keywordView = KeywordView()
        navigationController?.present(keywordView, animated: true)
    }
    
    
    @objc func confirmButtonTapped() {
        // 피커뷰에서 선택된 값을 가져오기
        let selectedCityRow = pickerView.pickerView.selectedRow(inComponent: 0)
        let selectedTownRow = pickerView.pickerView.selectedRow(inComponent: 1)
        
        let selectedCity = selectedCity[selectedCityRow]
        let selectedTown = selectedTown[selectedTownRow]
        
        // setLocationButton의 타이틀 업데이트
        searchView.setLocationButton.setTitle("\(selectedCity) \(selectedTown)", for: .normal)
        
        // PickerView 숨기기
        pickerView.removeFromSuperview()
        
        // 탭바 다시 보이게 하기
        tabBarController?.tabBar.isHidden = false
        
        // 뒷배경 흐리게 해제
        setOpacityView()

    }
    
    
    //MARK: - Configure UI
    
    func configureUI(){
        setSearchViewConstraints()
        setCollectionViewConstraints()
        setOpacityViewConstraints()
    }
    
    func setSearchViewConstraints(){
        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(232)
            
        }
    }
    
    func setCollectionViewConstraints(){
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-90)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    func setOpacityViewConstraints(){
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



//MARK: - CollectionView Delegate, DataSource, Layout

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier ,for: indexPath) as? SearchResultCell else {
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
        if collectionView.cellForItem(at: indexPath) is SearchResultCell {
            let matchingVC = MatchingVC()
            self.navigationController?.pushViewController(matchingVC, animated: true)
        }
    }
}



//MARK: - PickerView Delegate, DataSource

extension SearchVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
