//
//  loginViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController {
    
    //MARK: - UIComponent 선언
    private let logoView = UIImageView().then {
        let image = UIImage(systemName: "photo")
        $0.image = image
        $0.backgroundColor = .red
        $0.contentMode = .scaleAspectFit
    }
    
    // 아이디 textFieldView
    private lazy var idTextfieldView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(idTextField)
        $0.addSubview(idInfoLabel)
    }
    
    private var idInfoLabel = UILabel().then {
        $0.text = "아이디를 적어주세요"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var idTextField = UITextField().then {
        $0.backgroundColor = .blue
        $0.textColor = .white
        $0.keyboardType = .default
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 아이디 textFieldView
    private lazy var pwTextfieldView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(pwTextField)
        $0.addSubview(pwInfoLabel)
    }
    
    private var pwInfoLabel = UILabel().then {
        $0.text = "비밀번호를 적어주세요"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var pwTextField = UITextField().then {
        $0.backgroundColor = .blue
        $0.textColor = .white
        $0.keyboardType = .default
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .red
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
    
    private let altLoginButton = UIButton().then {
        let image = UIImage(systemName: "photo")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.clipsToBounds = true
    }
    
    private lazy var altButtonStack: UIStackView = {
        let stack = UIStackView()
        [altLoginButton, altLoginButton, altLoginButton].forEach{ stack.addArrangedSubview($0) }
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Function 선언
    func configure() {
        view.backgroundColor = .white
        idTextField.delegate = self
        
        [logoView, idTextfieldView, pwTextfieldView, loginButton, secondaryButtonStack, altButtonStack].forEach{view.addSubview($0)}
    }
    
    func setUI() {
        setLogo()
        setTextFields()
        setLoginBtn()
        setSearchBtn()
        alternativeLoginBtn()
    }
    
    private func setLogo() {
        logoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(124)
            $0.width.equalTo(186)
            $0.height.equalTo(90)
        }
    }
    
    private func setTextFields() {
        idTextfieldView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoView.snp.bottom).offset(84)
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
        
        idInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        idTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        pwTextfieldView.snp.makeConstraints {
            $0.top.equalTo(idTextfieldView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
        
        pwInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalTo(5)
        }
        
        pwTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func setLoginBtn() {
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextfieldView.snp.bottom).offset(140)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
    }
    
    func setSearchBtn() {
        secondaryButtonStack.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
    }
    
    func alternativeLoginBtn() {
        altButtonStack.snp.makeConstraints{
            $0.top.equalTo(secondaryButtonStack.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
        }
    }
    
    @objc func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func memberButtonTapped() {
        print("찐회원 버튼이 눌렸습니다.")
    }
    
    @objc func searchIdButtonTapped() {
        print("아이디 찾기 버튼이 눌렸습니다.")
        let vc = UserSearchController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func searchPwButtonTapped() {
        print("비밀번호 찾기 버튼이 눌렸습니다.")
    }
    
    deinit {
        print("로그인 페이지가 화면에서 내려갔습니다 - \(#function)")
    }
}

//MARK: - LifeCycle 선언
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("로그인 페이지 - \(#function)")
        
        configure()
        setUI()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}
