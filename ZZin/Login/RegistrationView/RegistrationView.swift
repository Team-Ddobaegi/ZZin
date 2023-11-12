//
//  RegistrationView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/11.
//

import UIKit

class RegistrationView: UIView {
    
    //MARK: - UIComponent 생성
    let nicknameTfView = CustomTextfieldView(placeholder: "", text: "닉네임", button: .cancelButton)
    let emailTfView = CustomTextfieldView(placeholder: "", text: "이메일", button: .cancelButton)
    let doublecheckEmailView = CustomTextfieldView(placeholder: "", text: "인증번호", button: .noButton)
    let pwTfView = CustomTextfieldView(placeholder: "", text: "비밀번호", button: .hideButton)
    let doublecheckPwView = CustomTextfieldView(placeholder: "", text: "비밀번호", button: .hideButton)
    
    var confirmButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    let backbutton = UIButton().then {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        
    }
    
    let locationButton = UIButton().then {
        let image = UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setTitle("지역 설정하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .black
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.snp.makeConstraints {$0.height.equalTo(52)}
    }
    
    private let infoLabel = UILabel().then {
        $0.text = "대문자로 시작하고 숫자로 마무리 지어주세요!"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .thin)
    }
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        [nicknameTfView, emailTfView].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        [doublecheckPwView, locationButton].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    //    private let checkButton = UIButton().then {
    //        $0.setTitle("중복", for: .normal)
    //        $0.setTitleColor(.red, for: .normal)
    //        $0.layer.cornerRadius = 12
    //        $0.clipsToBounds = true
    //        $0.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        backgroundColor = .white
        [backbutton, topStackView, doublecheckEmailView, pwTfView, infoLabel, stackView, confirmButton].forEach { addSubview($0) }
        pwTfView.textfield.isSecureTextEntry = true
        pwTfView.textfield.textContentType = .oneTimeCode
        doublecheckPwView.textfield.isSecureTextEntry = true
        doublecheckPwView.textfield.textContentType = .oneTimeCode
    }
    
    func setUI() {
        setBackButton()
        setTopStackView()
        // 에러시에만 실행
        setHidingEmailView()
        setPwTextView()
        setInfoLabel()
        setStackView()
        setConfirmButton()
    }
    
    private func setBackButton() {
        backbutton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(30)
        }
    }
    
    private func setTopStackView() {
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(298)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(353)
        }
    }
    
    // 사라지는 뷰
    private func setHidingEmailView() {
        doublecheckEmailView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(353)
        }
    }
    
    private func setPwTextView() {
        if doublecheckEmailView.isHidden {
            pwTfView.snp.makeConstraints {
                $0.top.equalTo(topStackView.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(353)
            }
        } else {
            pwTfView.snp.remakeConstraints {
                $0.top.equalTo(doublecheckEmailView.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(353)
            }
        }
        // 상황에 따라 다시 layout 잡는
        self.layoutIfNeeded()
    }
    
    private func setInfoLabel() {
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(pwTfView.snp.bottom).offset(5)
            $0.leading.equalTo(pwTfView.snp.leading).offset(5)
            $0.height.equalTo(20)
        }
    }
    
    private func setStackView() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(353)
        }
    }
    
    private func setConfirmButton() {
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(80)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    //    private func setCheckButton() {
    //        checkButton.snp.makeConstraints {
    //            $0.trailing.equalToSuperview().inset(20)
    //            $0.centerY.equalTo(emailTfView.snp.centerY)
    //            $0.size.equalTo(CGSize(width: 50, height: 50))
    //        }
    //    }
}