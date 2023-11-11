//
//  LoginView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/10.
//

import UIKit

class LoginView: UIView {
    let idTextfieldView = CustomTextfieldView(placeholder: "", text: "이메일", button: .cancelButton)
    let pwTextfieldView = CustomTextfieldView(placeholder: "", text: "비밀번호", button: .hideButton)
    
    private let logoView = UIImageView().then {
        let image = UIImage(named: "AppIcon")
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main.withAlphaComponent(0.5)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isEnabled = false
    }
    
    let memberButton = UIButton().then {
        $0.setTitle("찐회원 되기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        [idTextfieldView, pwTextfieldView, logoView, loginButton, memberButton].forEach{ addSubview($0) }
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
}
