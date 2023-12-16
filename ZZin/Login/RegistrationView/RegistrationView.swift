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
    
    let nicknameTfView = CustomTextfieldView(placeholder: "", text: "닉네임", alertMessage: "닉네임을 입력해주세요", button: .cancelButton)
    let emailTfView = CustomTextfieldView(placeholder: "", text: "이메일", alertMessage: "이메일을 입력해주세요", button: .checkButton)
    let doublecheckEmailView = CustomTextfieldView(placeholder: "", text: "인증번호", alertMessage: "인증번호 입력해주세요", button: .crossCheckButton)
    let pwTfView = CustomTextfieldView(placeholder: "", text: "비밀번호", alertMessage: "비밀번호를 입력해주세요", button: .hideButton)
    let doublecheckPwView = CustomTextfieldView(placeholder: "", text: "비밀번호 확인", alertMessage: "비밀번호를 화인해주세요", button: .hideButton)
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let lottieView: LottieAnimationView = LottieAnimationView(name: "lottieTest").then {
        $0.transform = CGAffineTransform(scaleX: 0.4, y: 0.4) // 크기 스케일링으로 인해 발생하는 autolayout 이슈
        $0.play()
        $0.contentMode = .scaleAspectFill
        $0.loopMode = .loop
    }
    
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
        [nicknameTfView, emailTfView].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stack = UIStackView()
        [pwStackView, doublecheckPwView].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    let noticeButton = UIButton().then {
        let image = UIImage(systemName: "square")?.withTintColor(ColorGuide.main, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    let noticeLabel = UILabel().then {
        $0.text = "회원가입 및 이용약관 동의"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    let linkLabel = UILabel().then {
        $0.text = "[상세 페이지로 이동하기]"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = ColorGuide.main
    }
    
    private lazy var noticeStackView: UIStackView = {
        let stack = UIStackView()
        [noticeButton, noticeLabel, linkLabel].forEach { stack.addArrangedSubview($0) }
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
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
        [scrollView].forEach { addSubview($0) }
        [backbutton, lottieView, registerStackView, passwordStackView, doublecheckEmailView, noticeStackView, locationButton, confirmButton].forEach { contentView.addSubview($0) }
        pwTfView.textfield.isSecureTextEntry = true
        pwTfView.textfield.textContentType = .oneTimeCode
        doublecheckPwView.textfield.isSecureTextEntry = true
        doublecheckPwView.textfield.textContentType = .oneTimeCode
    }
    
    func setUI() {
        enableScroll()
        configureUI()
        
        setHidingEmailView()
        setPwTextView()
        setAnimation()
    }
    
    private func enableScroll() {
        scrollView.snp.makeConstraints { // 스크롤뷰 적용
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView) // 스크롤뷰 내부 컴포넌트 적용
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // contentView 넓이 화면에 고정
        }
    }
        
    private func configureUI(){
        backbutton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        registerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(160)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordStackView.snp.makeConstraints {
            $0.top.equalTo(registerStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(passwordStackView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        locationButton.snp.makeConstraints {
            $0.top.equalTo(noticeStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(55)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    // 사라지는 뷰
    func setHidingEmailView() {
        doublecheckEmailView.snp.makeConstraints {
            $0.top.equalTo(registerStackView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setPwTextView() {
        if doublecheckEmailView.isHidden {
            passwordStackView.snp.makeConstraints {
                $0.top.equalTo(registerStackView.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview().inset(20)
            }
        } else {
            passwordStackView.snp.remakeConstraints {
                $0.top.equalTo(doublecheckEmailView.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview().inset(20)
            }
        }
        // 상황에 따라 다시 layout 잡는 함수
        self.layoutIfNeeded()
    }
    
    private func displayView() {
        doublecheckEmailView.isHidden = true
    }
    
    private func setAnimation() {
        lottieView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(-200)
        }
    }
}
