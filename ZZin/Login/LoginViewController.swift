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
    
    private let logoView = UIImageView().then {
        let image = UIImage(named: "AppIcon")
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    private let userData = Auth.auth().currentUser?.uid
    private let idTextfieldView = CustomTextfieldView(placeholder: "", text: "이메일", button: .cancelButton)
    private let pwTextfieldView = CustomTextfieldView(placeholder: "", text: "비밀번호", button: .hideButton)
    
    private var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main.withAlphaComponent(0.5)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let memberButton = UIButton().then {
        $0.setTitle("찐회원 되기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(memberButtonTapped), for: .touchUpInside)
    }
  
    //MARK: - 메서드 선언
    private func configure() {
        view.backgroundColor = .white
        [idTextfieldView, pwTextfieldView, logoView, loginButton, memberButton].forEach{view.addSubview($0)}
        pwTextfieldView.textfield.isSecureTextEntry = true
    }
    
    private func setUI() {
        setLogo()
        setCustomView()
        setLoginBtn()
        setMemberBtn()
    }
    
    private func setLogo() {
        logoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(124)
            $0.width.equalTo(186)
            $0.height.equalTo(90)
        }
    }
    
    private func setCustomView() {
        idTextfieldView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoView.snp.bottom).offset(84)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
        
        pwTextfieldView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextfieldView.snp.bottom).offset(20)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setLoginBtn() {
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextfieldView.snp.bottom).offset(140)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setMemberBtn() {
        memberButton.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
    }
    
    private func setDelegate() {
        idTextfieldView.setTextFieldDelegate(delegate: self)
        pwTextfieldView.setTextFieldDelegate(delegate: self)
    }
    
//    private func validateID(with email: String, completion: @escaping (Bool) -> Void) {
//        FireStoreManager.shared.crossCheckDB(email) { exists in
//            completion(exists)
//        }
//    }
    
    private func checkIdPattern(_ email: String) -> Bool {
        guard !email.isEmpty else {
            idTextfieldView.showInvalidMessage()
            showAlert(type: .idBlank)
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailpred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailpred.evaluate(with: email) else {
            idTextfieldView.showInvalidMessage()
            showAlert(type: .idWrongFormat)
            return false
        }
        return true
    }
    
    private func validPasswordPattern(_ password: String) -> Bool {
        guard !password.isEmpty else {
            pwTextfieldView.showInvalidMessage()
            showAlert(type: .passwordBlank)
            return false
        }
        
        let firstLetter = password.prefix(1)
        guard firstLetter == firstLetter.uppercased() else {
            print("첫 단어는 대문자가 필요합니다.")
            pwTextfieldView.showInvalidMessage()
            showAlert(type: .firstPasswordCap)
            return false
        }
        
        let numbers = password.suffix(1)
        guard numbers.rangeOfCharacter(from: .decimalDigits) != nil else {
            print("마지막은 숫자를 써주세요")
            pwTextfieldView.showInvalidMessage()
            showAlert(type: .lastPasswordNum)
            return false
        }
        return true
    }
    
    private func configureTextField() {
        idTextfieldView.textfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        pwTextfieldView.textfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func showAlert(type: ErrorHandling) {
        let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")

        guard let email = idTextfieldView.textfield.text, checkIdPattern(email) else {
            print("이메일 형식이 맞지 않습니다.")
            return
        }

        guard let pw = pwTextfieldView.textfield.text, validPasswordPattern(pw) else {
            print("비밀번호 형식이 맞지 않습니다.")
            return
        }

        AuthManager.shared.loginUser(with: email, password: pw) { success in
            if success {
                print("사용자가 로그인했습니다.")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                
//                print("로그인한 사용자는 ",loggedUser)
//                print("로그인한 사용자 uid ",loggedUser?.uid)
//                print("로그인한 사용자 providerID ",loggedUser?.providerID)
//                print("로그인한 사용자 email ",loggedUser?.email)
//                print("로그인한 사용자 name ",loggedUser?.displayName)
//                print("로그인한 사용자 num ",loggedUser?.phoneNumber)
//                print("로그인한 사용자 provider data ",loggedUser?.providerData)
//                print("로그인한 사용자 tenantID ",loggedUser?.tenantID)
            } else {
                print("사용자 로그인이 불가능합니다.")
                self.showAlert(type: .loginFailure)
            }
        }
    }
    
    @objc func memberButtonTapped() {
        print("찐회원 버튼이 눌렸습니다.")
        
        let vc = RegistrationViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func searchIdButtonTapped() {
        print("아이디 찾기 버튼이 눌렸습니다.")
        
        let vc = UserSearchController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func searchPwButtonTapped() {
        print("비밀번호 찾기 버튼이 눌렸습니다.")
        
        let vc = PasswordSearchController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == idTextfieldView.textfield {
            loginModel.email = sender.text
        } else {
            loginModel.password = sender.text
        }
        if loginModel.isValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = ColorGuide.main
        }
    }
    
    deinit {
        print("로그인 페이지가 화면에서 내려갔습니다")
    }
}

//MARK: - LifeCycle 선언
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = Auth.auth().currentUser
        print("현재 유저입니다. -",currentUser)
        setDelegate()
        configureTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        setUI()
    }
}

//MARK: - UITextFieldDelegate 선언
extension LoginViewController: UITextFieldDelegate {
    
    // 텍스트필드 수정 중 animatingLabel 숨기기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.idTextfieldView.textfield:
            idTextfieldView.animateLabel()
            idTextfieldView.textfield.placeholder = "honggildong@gmail.com"
        case self.pwTextfieldView.textfield:
            pwTextfieldView.animateLabel()
            pwTextfieldView.textfield.placeholder = "대문자 + 숫자 또는 특수문자 조합"
        default: print("textfield를 찾지 못했습니다.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextfieldView.textfield, let text = textField.text, text.isEmpty {
            idTextfieldView.undoLabelAnimation()
        } else if textField == pwTextfieldView.textfield, let text = textField.text, text.isEmpty {
            pwTextfieldView.undoLabelAnimation()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToTextfield(textField)
        return true
    }
    
    private func switchToTextfield(_ textField: UITextField) {
        print("다 써써용~")
        
        switch textField {
        case self.idTextfieldView.textfield:
            self.pwTextfieldView.textfield.becomeFirstResponder()
        case self.pwTextfieldView.textfield:
            self.pwTextfieldView.textfield.resignFirstResponder()
        default:
            self.pwTextfieldView.textfield.resignFirstResponder()
        }
    }
}
