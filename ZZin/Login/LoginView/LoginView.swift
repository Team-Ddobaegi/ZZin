//
//  LoginView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/10.
//

import UIKit

class LoginView: UIView {
    let idTextfieldView = CustomTextfieldView(placeholder: "", text: "이메일", alertMessage: "이메일이 비어있어요", button: .cancelButton)
    let pwTextfieldView = CustomTextfieldView(placeholder: "", text: "비밀번호", alertMessage: "비밀번호가 비어있어요", button: .hideButton)
    
    private let logoView = UIImageView().then {
        let image = UIImage(named: "AppIcon")
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main.withAlphaComponent(0.5)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isEnabled = false
    }
    
    let memberButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
//    let skipButton = UIButton().then {
//        $0.setTitle("로그인 건너뛰기", for: .normal)
//        $0.setTitleColor(.gray, for: .normal)
//        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .lightGray
        
        $0.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(10)
        }
    }
    
    lazy var memberStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memberButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        [idTextfieldView, pwTextfieldView, logoView, loginButton, memberStackView].forEach{ addSubview($0) }
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
            $0.top.equalToSuperview().offset(130)
            $0.width.height.equalTo(170)
        }
    }
    
    private func setCustomView() {
        idTextfieldView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoView.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
        
        pwTextfieldView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextfieldView.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
    }
    
    private func setLoginBtn() {
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextfieldView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
    }
    
    private func setMemberBtn() {
        memberStackView.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
        }
    }
}
