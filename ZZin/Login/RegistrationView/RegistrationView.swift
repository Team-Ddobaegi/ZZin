//
//  RegistrationView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/11.
//

import UIKit
import Lottie

class RegistrationView: UIView {
    
    //MARK: - UIComponent 생성
    
    let nicknameTfView = CustomTextfieldView(placeholder: "", text: "닉네임", button: .cancelButton)
    let emailTfView = CustomTextfieldView(placeholder: "", text: "이메일", button: .cancelButton)
    let doublecheckEmailView = CustomTextfieldView(placeholder: "", text: "인증번호", button: .noButton)
    let pwTfView = CustomTextfieldView(placeholder: "", text: "비밀번호", button: .hideButton)
    let doublecheckPwView = CustomTextfieldView(placeholder: "", text: "비밀번호 확인", button: .hideButton)
    
    let backbutton = UIButton().then {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        
    }
    
    private let infoLabel = UILabel().then {
        $0.text = "비밀번호는 대문자로 시작하고 특수문자로 끝나야 합니다."
        $0.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        $0.textColor = .lightGray
    }
    
    private lazy var pwStackView: UIStackView = {
        let stack = UIStackView()
        [pwTfView, infoLabel].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private lazy var registerStackView: UIStackView = {
        let stack = UIStackView()
        [nicknameTfView, emailTfView, doublecheckEmailView, pwStackView, doublecheckPwView].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    let noticeButton = UIButton().then {
        let image = UIImage(systemName: "square")?.withTintColor(ColorGuide.main, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
    }
    
    let noticeLabel = UILabel().then {
        $0.text = "회원가입 및 이용약관 동의 (탭 시, 상세 정보 확인)"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    private lazy var noticeStackView: UIStackView = {
        let stack = UIStackView()
        [noticeButton, noticeLabel].forEach { stack.addArrangedSubview($0) }
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    let locationButton = UIButton().then {
        $0.setTitle("지역 설정하기", for: .normal)
        $0.setTitleColor(ColorGuide.main, for: .normal)
        $0.layer.borderColor = ColorGuide.main.cgColor
        $0.layer.borderWidth = 1
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
 
    var confirmButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        displayView()
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        backgroundColor = .white
        [backbutton, registerStackView, noticeStackView, locationButton, confirmButton].forEach { addSubview($0) }
        pwTfView.textfield.isSecureTextEntry = true
        pwTfView.textfield.textContentType = .oneTimeCode
        doublecheckPwView.textfield.isSecureTextEntry = true
        doublecheckPwView.textfield.textContentType = .oneTimeCode
    }
    
    func setUI() {
        configureUI()
        
        // 에러시에만 실행
//        setHidingEmailView()
//        setPwTextView()
        setAnimation()
    }
    
    private func configureUI(){
        backbutton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
        }
        
        registerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(270)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(registerStackView.snp.bottom).offset(90)
            $0.left.right.equalToSuperview().inset(22)
        }
        
        locationButton.snp.makeConstraints {
            $0.top.equalTo(noticeStackView.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
    }
    
//    // 사라지는 뷰
//    private func setHidingEmailView() {
//        doublecheckEmailView.snp.makeConstraints {
//            $0.top.equalTo(registerStackView.snp.bottom).offset(20)
//            $0.centerX.equalToSuperview()
//            $0.left.right.equalToSuperview().inset(20)
//        }
//    }
//    
//    private func setPwTextView() {
//        if doublecheckEmailView.isHidden {
//            pwTfView.snp.makeConstraints {
//                $0.top.equalTo(registerStackView.snp.bottom).offset(20)
//                $0.left.right.equalToSuperview().inset(20)
//            }
//        } else {
//            pwTfView.snp.remakeConstraints {
//                $0.top.equalTo(doublecheckEmailView.snp.bottom).offset(20)
//                $0.left.right.equalToSuperview().inset(20)
//            }
//        }
//        // 상황에 따라 다시 layout 잡는
//        self.layoutIfNeeded()
//    }
    
    private func displayView() {
        doublecheckEmailView.isHidden = true
    }
    
    private func setAnimation() {
        let animationView = LottieAnimationView(name: "lottieTest")
        animationView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        animationView.contentMode = .scaleAspectFit
        addSubview(animationView)
        
        animationView.play()
        animationView.loopMode = .loop
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(-110)
//            $0.bottom.equalTo(nicknameTfView.snp.top)
        }
    }
}
