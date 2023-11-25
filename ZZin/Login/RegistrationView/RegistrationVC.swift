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
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let registrationView = RegistrationView()
    private var noticeButtonToggle = false
    
    // MARK: - LifeCycle 정리
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        dismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        addRegistrationSubview()
        addButtonTargets()
        setNotificationCenter()
        addLabelTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationCenter()
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
        registrationView.noticeButton.addTarget(self, action: #selector(noticeButtonTapped), for: .touchUpInside)
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
    
    @objc func dismissKeyboardOut() {
        view.endEditing(true)
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
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_-+=<>?/,.:;{}[]~`")
        
        guard numbers.rangeOfCharacter(from: specialCharacters) != nil else {
            print("마지막은 특수문자를 써주세요")
            registrationView.pwTfView.showInvalidMessage()
            showAlert(type: .firstTimePass)
            return false
        }
        
        guard password.count >= 8 else {
            print("8자리 이상으로 작성해주세요")
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
    
    private func addLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(noticeLabelTapped))
        registrationView.noticeLabel.isUserInteractionEnabled = true
        registrationView.noticeLabel.addGestureRecognizer(labelTap)
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
        
        guard registrationView.pwTfView.textfield.text == registrationView.doublecheckPwView.textfield.text else {
            showAlert(type: .equalPassword)
            return
        }
        
        guard noticeButtonToggle else {
            showAlert(type: .agreement)
            return
        }
        
        let credentials = AuthCredentials(email: id, password: pw, userName: nickname, description: "", profileImage: "profiles/default_profile.png", pid: [], rid: [])
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
                print("========== 어떤 오류인가요??",error?.localizedDescription)
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
        let vc = LocationView()
        vc.delegate = self
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(vc, animated: true)
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    @objc func noticeButtonTapped() {
        print("이용약관 버튼이 눌렸습니다.")
        
        if noticeButtonToggle == false {
            let selectedImage = UIImage(systemName: "square.fill")?.withTintColor(ColorGuide.main, renderingMode: .alwaysOriginal)
            registrationView.noticeButton.setImage(selectedImage, for: .normal)
            noticeButtonToggle = true
        } else {
            let Image = UIImage(systemName: "square")?.withTintColor(ColorGuide.main, renderingMode: .alwaysOriginal)
            registrationView.noticeButton.setImage(Image, for: .normal)
            noticeButtonToggle = false
        }
    }
    
    @objc func noticeLabelTapped() {
        print("라벨이 눌렸습니다.")
        guard let url = URL(string: "https://petalite-lan-d7b.notion.site/eabe5abe95304621b336440c79159696?pvs=4") else { return }
        UIApplication.shared.open(url)
    }
    
    deinit {
        print("Registration 화면이 내려갔습니다. \(#function)")
    }
}

extension RegistrationViewController {
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOut))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - UITextFieldDelegate 선언
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.registrationView.nicknameTfView.textfield:
            registrationView.nicknameTfView.animateLabel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.registrationView.nicknameTfView.hideInvalideMessage()
                self.registrationView.nicknameTfView.textfield.placeholder = "닉네임을 입력해주세요."
            }
        case self.registrationView.emailTfView.textfield:
            registrationView.emailTfView.animateLabel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.registrationView.emailTfView.hideInvalideMessage()
                self.registrationView.emailTfView.textfield.placeholder = "이메일을 입력해주세요."
            }
        case self.registrationView.pwTfView.textfield:
            registrationView.pwTfView.animateLabel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.registrationView.pwTfView.hideInvalideMessage()
                self.registrationView.pwTfView.textfield.placeholder = "비밀번호를 입력해주세요."
            }
        case self.registrationView.doublecheckPwView.textfield:
            registrationView.doublecheckPwView.animateLabel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.registrationView.doublecheckPwView.hideInvalideMessage()
                self.registrationView.doublecheckPwView.textfield.placeholder = "비밀번호를 입력해주세요."
            }
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

extension RegistrationViewController: sendDataDelegate {
    func sendData(data: String) {
        print(data)
        registrationView.locationButton.setTitle(data, for: .normal)
    }
}
