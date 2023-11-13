//
//  LocationView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/11.
//

import UIKit

protocol LocationViewDelegate: AnyObject {
    func didSelectValue(_ value: String)
}

class LocationView: UIViewController {
    //MARK: - 변수 && UIComponent 선언
    private let locationList: [String] = ["서울", "경기도", "인천", "세종", "부산", "대전", "대구", "광주", "울산", "경북", "경남", "충남", "충북", "제주"]
    private let locationPickerView = UIPickerView()
    private let registrationView = RegistrationView()
    weak var delegate: LocationViewDelegate?
    
    private let infoLabel = UILabel().then {
        $0.text = """
        관심 지역을\n선택해주세요
        """
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("선택했어요!", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setUI()
    }
    
    override func viewWillLayoutSubviews() {
        pickerViewUICustom()
    }
    
    //MARK: - 메서드 && 함수
    private func setUI() {
        [locationPickerView, infoLabel, confirmButton].forEach { view.addSubview($0) }
        setPickerView()
        setLabel()
        setButton()
    }
    
    private func setPickerView() {
        locationPickerView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setLabel() {
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(locationPickerView.snp.top).offset(-30)
        }
    }
    
    private func setButton() {
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationPickerView.snp.bottom).offset(30)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func pickerViewUICustom() {
        locationPickerView.subviews[1].backgroundColor = .clear
        let centerScreen = UIScreen.main.bounds.width
        let centerX = centerScreen/5
        
        let topLine = UIView(frame: CGRect(x: centerX, y: 0, width: 150, height: 0.8))
        let bottomLine = UIView(frame: CGRect(x: centerX, y: 60, width: 150, height: 0.8))
        
        [topLine, bottomLine].forEach{$0.backgroundColor = ColorGuide.main}
        
        locationPickerView.subviews[1].addSubview(topLine)
        locationPickerView.subviews[1].addSubview(bottomLine)
    }
    
    @objc func confirmButtonTapped() {
        dismiss(animated: true)
    }
    
    deinit {
        print("LocationView가 화면에서 내려갔습니다.")
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource 선언
extension LocationView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationList[row]
    }
}
extension LocationView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedLocation = locationList[row]
        delegate?.didSelectValue(selectedLocation)
    }
}