//
//  loginViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth
import SwiftUI

class LoginViewController: UIViewController {
    
    //MARK: - UIComponent 선언
    var loginModel = LoginModel()
    let loginView = LoginView()
    private let userData = Auth.auth().currentUser?.uid
    
    
    //MARK: - LifeCycle 선언
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        addButtonActions()
        configureTextField()
        dismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
    }
  
    //MARK: - 메서드 선언
    private func setView() {
        view.backgroundColor = .white
        view.addSubview(loginView)
        
        loginView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        loginView.idTextfieldView.setTextFieldDelegate(delegate: self)
        loginView.pwTextfieldView.setTextFieldDelegate(delegate: self)
    }
    
    private func addButtonActions() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.memberButton.addTarget(self, action: #selector(memberButtonTapped), for: .touchUpInside)
//        loginView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    private func configureTextField() {
        loginView.idTextfieldView.textfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        loginView.pwTextfieldView.textfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func checkIdPattern(_ email: String) -> Bool {
        guard !email.isEmpty else {
            loginView.idTextfieldView.showInvalidMessage()
            showAlert(type: .idBlank)
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailpred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailpred.evaluate(with: email) else {
            loginView.idTextfieldView.showInvalidMessage()
            showAlert(type: .idWrongFormat)
            return false
        }
        return true
    }
    
    private func validPasswordPattern(_ password: String) -> Bool {
        guard !password.isEmpty else {
            loginView.pwTextfieldView.showInvalidMessage()
            showAlert(type: .passwordBlank)
            return false
        }
        
        let firstLetter = password.prefix(1)
        guard firstLetter == firstLetter.uppercased() else {
            print("첫 단어는 대문자가 필요합니다.")
            loginView.pwTextfieldView.showInvalidMessage()
            showAlert(type: .firstPasswordCap)
            return false
        }
        
        let numbers = password.suffix(1)
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_-+=<>?/,.:;{}[]~`")
        guard numbers.rangeOfCharacter(from: specialCharacters) != nil else {
            print("마지막은 특수문자를 써주세요")
            loginView.pwTextfieldView.showInvalidMessage()
            showAlert(type: .lastPasswordNum)
            return false
        }
        return true
    }
    
    private func showAlert(type: ErrorHandling) {
        let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")

        guard let email = loginView.idTextfieldView.textfield.text, checkIdPattern(email) else {
            print("이메일 형식이 맞지 않습니다.")
            return
        }

        guard let pw = loginView.pwTextfieldView.textfield.text, validPasswordPattern(pw) else {
            print("비밀번호 형식이 맞지 않습니다.")
            return
        }

        AuthManager.shared.loginUser(with: email, password: pw) { success in
            if success {
                print("사용자가 로그인했습니다.")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            } else {
                print("사용자 로그인이 불가능합니다.")
                self.showAlert(type: .loginFailure)
            }
        }
    }
    
    @objc func skipButtonTapped() {
        print("로그인 건너뛰기")
//        
//        Auth.auth().signInAnonymously { (authResult, error) in
//            if let error = error {
//                print("익명 로그인을 하는데 오류가 발생했습니다.", error.localizedDescription)
//            } else {
//                guard let user = authResult?.user else { return }
//                let isAnonymous = user.isAnonymous
//                let uid = user.uid
//            }
//        }
//        let vc = TabBarViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: false)
    }
    
    @objc func memberButtonTapped() {
        print("찐회원 버튼이 눌렸습니다.")
        
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == loginView.idTextfieldView.textfield {
            loginModel.email = sender.text
        } else {
            loginModel.password = sender.text
        }
        if loginModel.isValid {
            loginView.loginButton.isEnabled = true
            loginView.loginButton.backgroundColor = ColorGuide.main
        }
    }
    
    @objc func dismissKeyboardOut() {
        view.endEditing(true)
    }
    
    deinit {
        print("로그인 페이지가 화면에서 내려갔습니다")
    }
}

extension LoginViewController {
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardOut))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

//MARK: - UITextFieldDelegate 선언
extension LoginViewController: UITextFieldDelegate {
    
    // 텍스트필드 수정 중 animatingLabel 숨기기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.loginView.idTextfieldView.textfield:
            loginView.idTextfieldView.animateLabel()
            loginView.idTextfieldView.textfield.placeholder = "honggildong@gmail.com"
        case self.loginView.pwTextfieldView.textfield:
            loginView.pwTextfieldView.animateLabel()
            loginView.pwTextfieldView.textfield.placeholder = "대문자 + 숫자 또는 특수문자 조합"
        default: print("textfield를 찾지 못했습니다.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == loginView.idTextfieldView.textfield, let text = textField.text, text.isEmpty {
            loginView.idTextfieldView.undoLabelAnimation()
        } else if textField == loginView.pwTextfieldView.textfield, let text = textField.text, text.isEmpty {
            loginView.pwTextfieldView.undoLabelAnimation()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToTextfield(textField)
        return true
    }
    
    private func switchToTextfield(_ textField: UITextField) {
        print("다 써써용~")
        
        switch textField {
        case self.loginView.idTextfieldView.textfield:
            self.loginView.pwTextfieldView.textfield.becomeFirstResponder()
        case self.loginView.pwTextfieldView.textfield:
            self.loginView.pwTextfieldView.textfield.resignFirstResponder()
        default:
            self.loginView.pwTextfieldView.textfield.resignFirstResponder()
        }
    }
}
