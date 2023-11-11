//
//  RegistrationViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    //MARK: - UIComponent 선언
    private var locationPickerView: UIPickerView!
    private let locationList: [String] = ["서울", "경기도", "인천", "세종", "부산", "대전", "대구", "광주", "울산", "경북", "경남", "충남", "충북", "제주"]
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 2
    private var selectedRow = 0
    private let registrationView = RegistrationView()
    
    // MARK: - LifeCycle 정리
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegate()
        self.displayView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addRegistrationSubview()
        self.navigationItem.hidesBackButton = true
        self.setNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotificationCenter()
    }
    
    //MARK: - 메서드 생성    
    private func addRegistrationSubview() {
        view.addSubview(registrationView)
        registrationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addButtonTargets() {
        registrationView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        registrationView.backbutton.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        registrationView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    // 나타날 때와 사라질 때 각가 필요한 2개의 메서드
    private func setNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 의문점 있음 -> better using protocol?
    private func setDelegate() {
        registrationView.emailTfView.setTextFieldDelegate(delegate: self)
        registrationView.pwTfView.setTextFieldDelegate(delegate: self)
        registrationView.nicknameTfView.setTextFieldDelegate(delegate: self)
        registrationView.doublecheckEmailView.setTextFieldDelegate(delegate: self)
        registrationView.doublecheckPwView.setTextFieldDelegate(delegate: self)
    }
    
    private func displayView() {
        registrationView.doublecheckEmailView.isHidden = true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(view.frame.origin.y)
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/2.5)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print(view.frame.origin.y)
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Auth 관련 함수
    private func checkIdPattern(_ email: String) -> Bool {
        guard !email.isEmpty else {
            registrationView.emailTfView.showInvalidMessage()
            showAlert(type: .idBlank)
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailpred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailpred.evaluate(with: email) else {
            registrationView.emailTfView.showInvalidMessage()
            showAlert(type: .firstTimeID)
            return false
        }
        return true
    }
    
    private func validPasswordPattern(_ password: String) -> Bool {
        guard !password.isEmpty else {
            registrationView.pwTfView.showInvalidMessage()
            showAlert(type: .passwordBlank)
            return false
        }
        
        let firstLetter = password.prefix(1)
        guard firstLetter == firstLetter.uppercased() else {
            print("첫 단어는 대문자가 필요합니다.")
            registrationView.pwTfView.showInvalidMessage()
            showAlert(type: .firstTimePass)
            return false
        }
        
        let numbers = password.suffix(1)
        guard numbers.rangeOfCharacter(from: .decimalDigits) != nil else {
            print("마지막은 숫자를 써주세요")
            registrationView.pwTfView.showInvalidMessage()
            showAlert(type: .firstTimeID)
            return false
        }
        
        guard password.count >= 8 else {
            print("8자리 이상 작성해주세요")
            registrationView.pwTfView.showInvalidMessage()
            showAlert(type: .tooShort)
            return false
        }
        return true
    }
    
    private func showAlert(type: ErrorHandling) {
        let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func confirmButtonTapped() {
        print("회원가입 버튼이 눌렸습니다.")
        
        guard let nickname = registrationView.nicknameTfView.textfield.text, !nickname.isEmpty else {
            registrationView.nicknameTfView.showInvalidMessage()
            showAlert(type: .doubleCheck)
            return
        }
        
        guard let id = registrationView.emailTfView.textfield.text, !id.isEmpty else {
            registrationView.emailTfView.showInvalidMessage()
            showAlert(type: .doubleCheck)
            return
        }
        
        guard checkIdPattern(id) else {
            registrationView.emailTfView.showInvalidMessage()
            showAlert(type: .idError)
            return
        }
        
        guard let pw = registrationView.pwTfView.textfield.text, !pw.isEmpty else {
            registrationView.pwTfView.showInvalidMessage()
            showAlert(type: .doubleCheck)
            return
        }
        
        guard validPasswordPattern(pw) else {
            registrationView.pwTfView.showInvalidMessage()
            showAlert(type: .passwordBlank)
            return
        }
        
        let credentials = AuthCredentials(email: id, password: pw, userName: nickname)
        AuthManager.shared.registerNewUser(with: credentials) { success, error in

            if success {
                print("유저가 생성되었습니다.")
                DispatchQueue.main.async {
                    let mainVC = TabBarViewController()
                    let testVC = CardController()
                    testVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(mainVC, animated: true)
                    self.present(testVC, animated: true)
                }
            } else {
                print("========== 어떤 오류인가요??",error.localizedDescription)
                self.registrationView.emailTfView.showInvalidMessage()
                self.showAlert(type: .alreadyExists)
            }
        }
    }
    
    @objc func backbuttonTapped() {
        print("되돌아가기 버튼이 눌렸습니다.")
        navigationController?.popViewController(animated: true)
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
        alert.popoverPresentationController?.sourceView = registrationView.locationButton
        alert.popoverPresentationController?.sourceRect = registrationView.locationButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "되돌아가기", style: .cancel, handler: { (UIAlertAction) in
        }))
        alert.addAction(UIAlertAction(title: "선택하기", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = locationPickerView.selectedRow(inComponent: 0)
            let selected = Array(self.locationList)[self.selectedRow]
            self.registrationView.locationButton.setTitle(selected, for: .normal)
            self.registrationView.locationButton.backgroundColor = ColorGuide.main
        }))
        
        self.present(alert, animated: true)
    }
    
    deinit {
        print("Registration 화면이 내려갔습니다. \(#function)")
    }
}

// MARK: - UITextFieldDelegate 선언
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.registrationView.nicknameTfView.textfield:
            registrationView.nicknameTfView.animateLabel()
            registrationView.nicknameTfView.textfield.placeholder = "나만의 닉넴은?"
        case self.registrationView.emailTfView.textfield:
            registrationView.emailTfView.animateLabel()
            registrationView.emailTfView.textfield.placeholder = "자주 쓰는 이메일이 있나요?"
        case self.registrationView.pwTfView.textfield:
            registrationView.pwTfView.animateLabel()
            registrationView.pwTfView.textfield.placeholder = "철통보안!"
        case self.registrationView.doublecheckPwView.textfield:
            registrationView.doublecheckPwView.animateLabel()
            registrationView.doublecheckPwView.textfield.placeholder = "비밀번호를 다시 한번 입력해주세요"
        default: print("textfield를 찾지 못했습니다.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == registrationView.nicknameTfView.textfield, let text = textField.text, text.isEmpty {
            registrationView.nicknameTfView.undoLabelAnimation()
        } else if textField == registrationView.emailTfView.textfield, let text = textField.text, text.isEmpty {
            registrationView.emailTfView.undoLabelAnimation()
        } else if textField == registrationView.pwTfView.textfield, let text = textField.text, text.isEmpty {
            registrationView.pwTfView.undoLabelAnimation()
        } else if textField == registrationView.doublecheckPwView.textfield, let text = textField.text, text.isEmpty {
            registrationView.doublecheckPwView.undoLabelAnimation()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToTextfield(textField)
        return true
    }
    
    private func switchToTextfield(_ textField: UITextField) {
        let email = registrationView.emailTfView.textfield.text!
        let password = registrationView.pwTfView.textfield.text!
        
        switch textField {
        case self.registrationView.nicknameTfView.textfield:
            self.registrationView.emailTfView.textfield.becomeFirstResponder()
        case self.registrationView.emailTfView.textfield:
            checkIdPattern(email) ? self.registrationView.pwTfView.textfield.becomeFirstResponder() : self.registrationView.emailTfView.textfield.becomeFirstResponder()
        case self.registrationView.pwTfView.textfield:
            validPasswordPattern(password) ? self.registrationView.doublecheckPwView.textfield.becomeFirstResponder() : self.registrationView.pwTfView.textfield.becomeFirstResponder()
        case self.registrationView.doublecheckPwView.textfield:
            self.registrationView.doublecheckPwView.textfield.resignFirstResponder()
        default:
            self.registrationView.doublecheckPwView.textfield.resignFirstResponder()
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
