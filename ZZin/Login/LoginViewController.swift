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
    
    private let idTextfield = CustomTextfieldView(placeholder: "honggildong@gmail.com", text: "이메일", hasEyeButton: false)
    private let pwTextfield = CustomTextfieldView(placeholder: "대문자 + 숫자 또는 특수문자 조합", text: "비밀번호", hasEyeButton: true)
    
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
    
    private lazy var secondaryButtonStack: UIStackView = {
        let stack = UIStackView()
        [memberButton, searchIdButton, searchPwButton].forEach{ stack.addArrangedSubview($0) }
        [memberButton, searchIdButton, searchPwButton].forEach { $0.titleLabel?.font = UIFont.systemFont(ofSize: 15) }
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - 메서드 선언
    func configure() {
        view.backgroundColor = .white
        [idTextfield, pwTextfield, logoView, loginButton, secondaryButtonStack].forEach{view.addSubview($0)}
    }
    
    func setUI() {
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
        idTextfield.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoView.snp.bottom).offset(84)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
        
        pwTextfield.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextfield.snp.bottom).offset(20)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setLoginBtn() {
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextfield.snp.bottom).offset(140)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    func setSearchBtn() {
        secondaryButtonStack.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
    }
    
    private func setDelegate() {
        // deep copy와 Shallow copy의 차이점
        //        idTextfield.textfield.delegate = self
        //        pwTextfield.textfield.delegate = self
        // shallow copy
        idTextfield.setTextFieldDelegate(delegate: self)
        pwTextfield.setTextFieldDelegate(delegate: self)
    }
    
    @objc func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
    // 텍스트 필드가 입력되고 있는지 확인, 확인된 텍스트 필드의 label을 없애야 하는 상황
    func textFieldDidBeginEditing(_ textFieldView: UITextField) {
        switch textFieldView {
        case idTextfield: idTextfield.animatingLabel.isHidden = true
        case pwTextfield: pwTextfield.animatingLabel.isHidden = true
        default: print("textfield를 찾지 못했습니다.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        return false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let emailText = textField.text else { return }

        if textField == idTextfield.textfield {
            if idTextfield.validateEmail(emailText) {
                idTextfield.animatingLabel.isHidden = !idTextfield.textfield.text!.isEmpty
//                idTextfield.undo()
            } else {
                idTextfield.showInvalidMessage()
            }
            textField.text = ""
        } else if textField == pwTextfield {
            pwTextfield.animatingLabel.isHidden = !pwTextfield.textfield.text!.isEmpty
        }
    }
}
