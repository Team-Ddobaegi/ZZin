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
    
    private let emailTextFieldView = CustomTextfieldView(placeholder: "", text: "이메일")
    private let pwTextFieldView = CustomTextfieldView(placeholder: "", text: "비밀번호", hasEyeButton: false)
    private let nicknameTextFieldView = CustomTextfieldView(placeholder: "", text: "닉네임")
    private let numberTextFieldView = CustomTextfieldView(placeholder: "", text: "전화번호")
    private var locationPickerView: UIPickerView!
    private let locationList: [String] = ["서울", "경기도", "인천", "세종", "부산", "대전", "대구", "광주", "울산", "경북", "경남", "충남", "충북", "제주"]
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 2
    private var selectedRow = 0
    
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
        [emailTextFieldView, pwTextFieldView, nicknameTextFieldView, numberTextFieldView, confirmButton, backbutton, locationButton].forEach{view.addSubview($0)}
    }
    
    private func setUI() {
        setBackButton()
        setIdTextfieldView()
        setPwTextFieldView()
        setLocation()
        setNicknameTextFieldView()
        setNumberTextfieldView()
        setConfirmButton()
    }
    
    private func setIdTextfieldView() {
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(282)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setPwTextFieldView() {
        pwTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setLocation() {
        locationButton.snp.makeConstraints {
            $0.top.equalTo(pwTextFieldView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setNicknameTextFieldView() {
        nicknameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setNumberTextfieldView() {
        numberTextFieldView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setConfirmButton() {
        confirmButton.snp.makeConstraints{
            $0.top.equalTo(numberTextFieldView.snp.bottom).offset(61)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setBackButton() {
        backbutton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(30)
        }
    }
    
    private func setDelegate() {
        emailTextFieldView.setTextFieldDelegate(delegate: self)
        pwTextFieldView.setTextFieldDelegate(delegate: self)
        nicknameTextFieldView.setTextFieldDelegate(delegate: self)
        numberTextFieldView.setTextFieldDelegate(delegate: self)
    }
    
    private func validPasswordPattern(_ password: String) -> Bool {
        guard !password.isEmpty else { return false }
        
        let firstLetter = password.prefix(1)
        guard firstLetter == firstLetter.uppercased() else { print("첫 단어는 대문자가 필요합니다."); return false }
        
        let numbers = password.suffix(1)
        guard numbers.rangeOfCharacter(from: .decimalDigits) != nil else { print("마지막은 숫자를 써주세요"); return false }
        return true
    }
    
    func validateNumberPattern(_ number: String) -> Bool {
        if number.isEmpty {
            print("번호가 입력이 되지 않았어요")
            return false
        } else if Int(number) == nil {
            print("번호 형식을 맞춰주세요")
            return false
        } else if number.count != 11 {
            print("번호가 짧아요")
            return false
        }
        return true
    }
    
    private func showAlert(type: ErrorHandling) {
        let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkIdPattern(_ email: String) -> Bool {
        return true
    }
    
    @objc func confirmButtonTapped() {
        print("회원가입 버튼이 눌렸습니다.")
        
        let id = emailTextFieldView.textfield.text!
        let pw = pwTextFieldView.textfield.text!
        
        guard validPasswordPattern(pw) else {
            showAlert(type: .passwordError)
            return
        }
        
        FireStoreManager.shared.signIn(with: id, password: pw) { success in
            if success {
                print("유저가 생성되었습니다.")
                self.dismiss(animated: true)
            } else {
                print("다시 수정해주세요")
            }
        }
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
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        setUI()
    }
}

// MARK: - UITextFieldDelegate 선언
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.emailTextFieldView.textfield: emailTextFieldView.textfield.placeholder = "자주 쓰는 이메일이 있나요?"
        case self.nicknameTextFieldView.textfield: nicknameTextFieldView.textfield.placeholder = "나만의 닉넴은?"
        case self.numberTextFieldView.textfield: numberTextFieldView.textfield.placeholder = "여러분의 전화번호를 적어주세요"
        case self.pwTextFieldView.textfield: pwTextFieldView.textfield.placeholder = "철통보안!"
        default: print("textfield를 찾지 못했습니다.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextFieldView.textfield, let text = textField.text, text.isEmpty {
            emailTextFieldView.undoLabelAnimation()
        } else if textField == nicknameTextFieldView.textfield, let text = textField.text, text.isEmpty {
            nicknameTextFieldView.undoLabelAnimation()
        } else if textField == numberTextFieldView.textfield, let text = textField.text, text.isEmpty {
            numberTextFieldView.undoLabelAnimation()
        } else if textField == pwTextFieldView.textfield, let text = textField.text, text.isEmpty {
            pwTextFieldView.undoLabelAnimation()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToTextfield(textField)
        return true
    }
    
    private func switchToTextfield(_ textField: UITextField) {
        print("다 써써용~")
        switch textField {
        case self.emailTextFieldView.textfield:
            self.nicknameTextFieldView.textfield.becomeFirstResponder()
        case self.nicknameTextFieldView.textfield:
            self.numberTextFieldView.textfield.becomeFirstResponder()
        case self.numberTextFieldView.textfield:
            self.pwTextFieldView.textfield.becomeFirstResponder()
        case self.pwTextFieldView.textfield:
            self.pwTextFieldView.textfield.resignFirstResponder()
        default:
            self.pwTextFieldView.textfield.resignFirstResponder()
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
