//
//  RegistrationViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit
import Then

class RegistrationViewController: UIViewController {
    
    //MARK: - UIComponent 생성
    
    private let emailTextField = CustomTextfieldView(placeholder: "honggildong@gmail.com", text: "이메일")
    private let pwTextField = CustomTextfieldView(placeholder: "대문자는 필수입니다! 숫자 또는 특수문자도 섞어주세요 ☺️", text: "비밀번호", hasEyeButton: false)
    private let nicknameTextField = CustomTextfieldView(placeholder: "내가젤잘나가", text: "닉네임")
    private let numberTextField = CustomTextfieldView(placeholder: "010-0000-0000", text: "전화번호")
    private var locationPickerView: UIPickerView!
    var locationList: [String] = ["서울", "경기도", "인천", "세종", "부산", "대전", "대구", "광주", "울산", "경북", "경남", "충남", "충북", "제주"]
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    
//    private lazy var doubleCheckButton = UIButton().then {
//        $0.setTitle("중복 확인", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
//        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        $0.backgroundColor = .red
//        $0.clipsToBounds = true
//        $0.addTarget(self, action: #selector(doubleCheckButtonTapped), for: .touchUpInside)
//    }
    
    private var confirmButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.init(hexCode: "F55951")
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private let backbutton = UIButton().then {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
    }
    
    private let locationButton = UIButton().then {
        let image = UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setTitle("지역 설정하기", for: .normal)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .gray
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - 메서드 생성
    func configure() {
        view.backgroundColor = .white
        [emailTextField, pwTextField, nicknameTextField, numberTextField, confirmButton, backbutton, locationButton].forEach{view.addSubview($0)}
    }
    
    func setUI() {
        setIdTextfield()
        setPwTextField()
        setLocation()
        setNicknameTextField()
        setNumberTextfield()
        setConfirmButton()
        setBackButton()
    }
    
    func setIdTextfield() {
        emailTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(282)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setPwTextField() {
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setLocation() {
        locationButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setNicknameTextField() {
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setNumberTextfield() {
        numberTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setConfirmButton() {
        confirmButton.snp.makeConstraints{
            $0.top.equalTo(numberTextField.snp.bottom).offset(61)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setBackButton() {
        backbutton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(30)
        }
    }
    
    private func setDelegate() {
        emailTextField.setTextFieldDelegate(delegate: self)
        pwTextField.setTextFieldDelegate(delegate: self)
        nicknameTextField.setTextFieldDelegate(delegate: self)
        numberTextField.setTextFieldDelegate(delegate: self)
    }
    
    @objc func confirmButtonTapped() {
        print("회원가입 버튼이 눌렸습니다.")
        let id = emailTextField.textfield.text!
        let pw = pwTextField.textfield.text!
        FireStoreManager.shared.signIn(with: id, password: pw)
    }
    
    @objc func doubleCheckButtonTapped() {
        print("중복 확인 버튼이 눌렸습니다.")
        
    }
    
    @objc func backbuttonTapped() {
        print("되돌아가기 버튼이 눌렸습니다.")
        self.dismiss(animated: true)
    }
    
    @objc func locationButtonTapped() {
        print("지역 확인 버튼이 눌렸습니다.")
        
        // alertController로 지역 리스트 팝업
        let vc = ViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        vc.view.backgroundColor = .white
        let locationPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        locationPickerView.dataSource = self
        locationPickerView.delegate = self
        
        locationPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(locationPickerView)
        locationPickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        locationPickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "지역을 선택하세요", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = locationButton
        alert.popoverPresentationController?.sourceRect = locationButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "되돌아가기", style: .cancel, handler: { (UIAlertAction) in
        }))
        alert.addAction(UIAlertAction(title: "선택하기", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = locationPickerView.selectedRow(inComponent: 0)
            let selected = Array(self.locationList)[self.selectedRow]
            self.locationButton.setTitle(selected, for: .normal)
            self.locationButton.backgroundColor = .orange
        }))
        
        self.present(alert, animated: true)
    }
    
    deinit {
        print("Registration 화면이 내려갔습니다. \(#function)")
    }
}

// MARK: - LifeCycle 정리
extension RegistrationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        setDelegate()
        setUI()
        setDelegate()
    }
}

// MARK: - UITextFieldDelegate 선언
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textFieldView: UITextField) {
        switch textFieldView {
        case emailTextField: emailTextField.animatingLabel.isHidden = true
        case pwTextField: pwTextField.animatingLabel.isHidden = true
        case nicknameTextField: nicknameTextField.animatingLabel.isHidden = true
        case numberTextField: numberTextField.animatingLabel.isHidden = true
        default: print("textfield를 찾지 못했습니다.")
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource 선언
extension RegistrationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(locationList)[row]
        label.sizeToFit()
        return label
    }
}

extension RegistrationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}
