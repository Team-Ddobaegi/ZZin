//
//  loginViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    //MARK: - UIComponent 선언
    private let logoView: UIImageView = {
        let image = UIImage(systemName: "photo")
        let iv = UIImageView()
        iv.image = image
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // 아이디 textFieldView
    private lazy var idTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(idTextField)
        view.addSubview(idInfoLabel)
        return view
    }()
    
    private var idInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디를 적어주세요"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var idTextField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .blue
        tf.textColor = .white
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // 아이디 textFieldView
    private lazy var pwTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(pwTextField)
        view.addSubview(pwInfoLabel)
        return view
    }()
    
    private var pwInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 적어주세요"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var pwTextField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .blue
        tf.textColor = .white
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private var loginButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("로그인", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: - Function 선언
    func configure() {
        view.backgroundColor = .white
        idTextField.delegate = self
        
        [logoView, idTextfieldView, pwTextfieldView].forEach{view.addSubview($0)}
    }
    
    func setUI() {
        setLogo()
        setTextFields()
        setLoginBtn()
    }
    
    private func setLogo() {
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(124)
            make.width.equalTo(186)
            make.height.equalTo(90)
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
    
    @objc func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")
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
