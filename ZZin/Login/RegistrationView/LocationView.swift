//
//  LocationView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/11.
//

import UIKit

protocol sendDataDelegate: AnyObject {
    func sendData(data: String)
}

class LocationView: UIViewController {
    //MARK: - 변수 && UIComponent 선언
    private let locationList: [String] = ["", "서울", "경기도"]
    private let locationPickerView = UIPickerView()
    private let registrationView = RegistrationView()
    private var selectedLocation: String?
    weak var delegate: sendDataDelegate? // weak로 설정했을 때 locationView가 화면에서 내려가면서 발생하는 이슈 고민
    
    private let infoLabel = UILabel().then {
        $0.text = """
        관심 지역을\n선택해주세요
        """
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        $0.textColor = .black
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
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    private func setButton() {
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationPickerView.snp.bottom)
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview().inset(20)
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
        print("버튼이 눌렸습니다.")
        delegate?.sendData(data: self.selectedLocation ?? "없음")
        dismiss(animated: true)
    }
    
    deinit {
        print("LocationView가 화면에서 내려갔습니다.")
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource 선언
extension LocationView: UIPickerViewDelegate {
    
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
        self.selectedLocation = locationList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = locationList[row]
        let color: UIColor = .black
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
