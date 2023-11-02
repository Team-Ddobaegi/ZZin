//
//  MatchingLocationPickerVC.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/30/23.
//

import UIKit

protocol LocationPickerViewDelegate: AnyObject {
    func updateLocation(city: String?, town: String?)
}

class MatchingLocationPickerVC: UIViewController {
    
    // MARK: - Properties
    
    weak var pickerViewDelegate: LocationPickerViewDelegate?
    let pickerViewUI = MatchingLocationPickerView()
    var selectedCity: String? = "지역"
    var selectedTown: String? = "미설정"
    
    // 선택된 "시"와 "구"의 인덱스
    var selectedCityIndex: Int = 0
    var selectedTownIndex: Int = 0
    
    // 피커뷰 1열에 들어갈 "시"
    let cities = ["서울", "인천"] // "시"에 대한 데이터 배열
   
    // 피커뷰 2열에 들어갈 "구"
    let seoulTowns = ["전체", "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]
    let incheonTowns = ["전체", "부평구", "연수구", "미추홀구"]

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setConfirmButton()
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
        print("deinit MatchingLocationPickerVC")
    }
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .white
        view.addSubview(pickerViewUI)
        
        pickerViewUI.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pickerViewUI.pickerView.delegate = self
        pickerViewUI.pickerView.dataSource = self
    }
    
    private func setConfirmButton(){
        pickerViewUI.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private func selectedLocation(){
        // 피커뷰에서 선택된 값을 가져오기
        let selectedCityRow = pickerViewUI.pickerView.selectedRow(inComponent: 0)
        let selectedTownRow = pickerViewUI.pickerView.selectedRow(inComponent: 1)
        
        // 'selectedCityIndex'를 첫 번째 열(시)에서 선택한 값으로 설정
        selectedCityIndex = selectedCityRow
        // 'selectedTownIndex'를 두 번째 열(구)에서 선택한 값으로 설정
        selectedTownIndex = selectedTownRow
        
        self.selectedCity = cities[selectedCityIndex]
        self.selectedTown = selectedCityIndex == 0 ? seoulTowns[selectedTownIndex] : incheonTowns[selectedTownIndex]
    }
    
    func updateLocation(city: String?, town: String?){
        let updateCity = city
        let updateTown = town
        
        pickerViewDelegate?.updateLocation(city: updateCity, town: updateTown)
    }
    
    // MARK: - Actions
    
    @objc func confirmButtonTapped() {
//        print("확인 버튼 탭")
        
        selectedLocation()

        updateLocation(city: self.selectedCity, town: self.selectedTown)
        
        print("-----------------------","\(self.selectedCity ?? "지역") \(self.selectedTown ?? "미설정")")
        self.dismiss(animated: true)
    }
}




//MARK: - PickerView Delegate, DataSource

extension MatchingLocationPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
