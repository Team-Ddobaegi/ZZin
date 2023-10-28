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
    private let logoView = UIImageView().then {
        let image = UIImage(named: "ZZin")
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    private let idTextfieldView = CustomTextfieldView(placeholder: "", text: "이메일", hasEyeButton: false)
    private let pwTextfieldView = CustomTextfieldView(placeholder: "", text: "비밀번호", hasEyeButton: true)
    
    private var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let memberButton = UIButton().then {
        $0.setTitle("찐회원 되기 ㅣ", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(memberButtonTapped), for: .touchUpInside)
    }
    
    private let searchIdButton = UIButton().then {
        $0.setTitle("아이디 찾기 ㅣ", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(searchIdButtonTapped), for: .touchUpInside)
    }
    
    private let searchPwButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(searchPwButtonTapped), for: .touchUpInside)
    }
    
    private lazy var userButtonStack: UIStackView = {
        let stack = UIStackView()
        [memberButton, searchIdButton, searchPwButton].forEach{ stack.addArrangedSubview($0) }
        [memberButton, searchIdButton, searchPwButton].forEach { $0.titleLabel?.font = UIFont.systemFont(ofSize: 15) }
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - 메서드 선언
    private func configure() {
        view.backgroundColor = .white
        [idTextfieldView, pwTextfieldView, logoView, loginButton, userButtonStack].forEach{view.addSubview($0)}
        pwTextfieldView.textfield.isSecureTextEntry = true
    }
    
    private func setUI() {
        setLogo()
        setCustomView()
        setLoginBtn()
        setSearchBtn()
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
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    private func setSearchBtn() {
        userButtonStack.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
    }
    
    private func setDelegate() {
        idTextfieldView.setTextFieldDelegate(delegate: self)
        pwTextfieldView.setTextFieldDelegate(delegate: self)
    }
    
    private func validateID(with email: String, completion: @escaping (Bool) -> Void) {
        FireStoreManager.shared.crossCheckDB(email) { exists in
            completion(exists)
        }
    }
    
    @objc func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")
        
        let email = idTextfieldView.textfield.text!
        self.validateID(with: email) { exists in
            if exists {
                print("허가")
//                let vc = TabBarViewController()
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true)
            } else {
                print("불허가")
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
        let vc = UserSearchController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    deinit {
        print("로그인 페이지가 화면에서 내려갔습니다")
    }
}

//MARK: - LifeCycle 선언
extension LoginViewController {
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

//MARK: - UITextFieldDelegate 선언
extension LoginViewController: UITextFieldDelegate {
    
    // 텍스트필드 수정 중 animatingLabel 숨기기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.idTextfieldView.textfield: idTextfieldView.textfield.placeholder = "honggildong@gmail.com"
        case self.pwTextfieldView.textfield: pwTextfieldView.textfield.placeholder = "대문자 + 숫자 또는 특수문자 조합"
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
