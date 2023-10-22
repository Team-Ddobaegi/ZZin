//
//  RegistrationViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase

class RegistrationViewController: UIViewController {
    
    private lazy var idTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(idTextField)
        view.addSubview(idInfoLabel)
        view.addSubview(doubleCheckButton)
        return view
    }()
    
    private var idInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디를 입력해 주세요"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var idTextField: UITextField = {
        var tf = UITextField()
        tf.textColor = .white
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
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
        label.text = "비밀번호를 입력해 주세요"
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
    
    private lazy var checkPwTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(checkPwTextField)
        view.addSubview(checkPwInfoLabel)
        return view
    }()
    
    private var checkPwInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "한번만 더 입력해 주세요"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var checkPwTextField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .blue
        tf.textColor = .white
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var nicknameTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameInfoLabel)
        view.addSubview(doubleCheckButton)
        return view
    }()
    
    private var nicknameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해 주세요"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nicknameTextField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .blue
        tf.textColor = .white
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var numberTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(numberTextField)
        view.addSubview(numberInfoLabel)
        return view
    }()
    
    private var numberInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "전화 번호를 입력해주세요"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var numberTextField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .blue
        tf.textColor = .white
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private var doubleCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doubleCheckButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func configure() {
        view.backgroundColor = .yellow
        self.title = "되나"
        [idTextfieldView, pwTextfieldView, checkPwTextfieldView, nicknameTextfieldView, numberTextfieldView, confirmButton].forEach{view.addSubview($0)}
    }
    
    func setUI() {
        setIdTextfield()
        setPwTextField()
        setNicknameTextfield()
        setNumberTextfield()
        setConfirmButton()
    }
    
    func setIdTextfield() {
        idTextfieldView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(184)
            $0.centerX.equalToSuperview()
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
        
        doubleCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(idTextfieldView.snp.trailing).inset(6)
        }
    }
    
    func setIdButton() {
        doubleCheckButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    func setPwTextField() {
        pwTextfieldView.snp.makeConstraints {
            $0.top.equalTo(idTextfieldView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
        
        pwInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        pwTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        checkPwTextfieldView.snp.makeConstraints {
            $0.top.equalTo(pwTextfieldView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
        
        checkPwInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        checkPwTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func setNicknameTextfield() {
        nicknameTextfieldView.snp.makeConstraints {
            $0.top.equalTo(checkPwTextfieldView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
        
        nicknameInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        doubleCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(nicknameTextfieldView.snp.trailing).inset(6)
            $0.width.equalTo(73)
            $0.height.equalTo(33)
        }
    }
    
    func setNumberTextfield() {
        numberTextfieldView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextfieldView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
        
        numberInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        numberTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func setConfirmButton() {
        confirmButton.snp.makeConstraints{
            $0.top.equalTo(numberTextfieldView.snp.bottom).offset(149)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(353)
        }
    }
    
    func setDelegate() {
        idTextField.delegate = self
        pwTextField.delegate = self
        checkPwTextField.delegate = self
        nicknameTextField.delegate = self
        numberTextField.delegate = self
    }
    
    func validateData() -> String? {
        // idLabel과 pwLabel의 값이 들어가 있는지만 확인하면 되잖아
        if idTextField.state.isEmpty || pwTextField.state.isEmpty || nicknameTextField.state.isEmpty {
            print("비어있는 값이 있는지 확인해주세요.")
        }
        // 비밀번호가 안전한지 확인 - 8자 이상, 대문자 / 소문자 / 숫자 조합인지 확인
        let checkedPassword = pwTextField.text!
        if validatePassword(checkedPassword) == false {
            return "비밀번호가 8자 이상, 숫자와 특수문자가 최소 1개씩 들어갔는지 확인해주세요!"
        }
        return nil
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordCheck = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordCheck)
        return predicate.evaluate(with: password)
    }
    
    @objc func confirmButtonTapped() {
        print("확인 버튼이 눌렸습니다.")
        
        // 값이 모두 입력됐는지 확인
        let error = validateData()
        if error != nil {
            
            // validate 함수에서 에러가 발생!
            print("에러가 발생했습니다. \(error)")
        } else {
            
            // clean 아이디와 비밀번호가 있는지 확인 완료
            let checkedId = idTextField.text!
            let checkedPassword = pwTextField.text!
            
            // 유저 생성 - Firebase가 가지고 있는 함수를 활용해서 사용자 생성
            Auth.auth().createUser(withEmail: checkedId, password: checkedPassword) { result, error in
                guard let error = error else {
                    print("에러가 발생했습니다. - \(error?.localizedDescription)")
                    return
                }
                
                // 유저가 에러 없었다! 생성이 되야 한다는 점
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["id": checkedId, "password": checkedPassword, "uid": result?.user.uid]) { error in
                    // 이 단계에서 데이터 저장 관련 에러를 확인하는 과정을 거치는게 맞나? >> error != nil이 맞나?
                    if error != nil {
                        print("저장하는데 에러가 발생했습니다.")
                    }
                }
                
            }
            print("회원가입이 완료되었습니다.")
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        // 화면 전환
    }
    
    @objc func doubleCheckButtonTapped() {
        print("중복 확인 버튼이 눌렸습니다.")
    }
    
    deinit {
        print("Registration 화면이 내려갔습니다. \(#function)")
    }
}

// MARK: - LifeCycle 정리
extension RegistrationViewController {
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

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case idTextField: idInfoLabel.isHidden = true
        case pwTextField: pwInfoLabel.isHidden = true
        case checkPwTextField: checkPwInfoLabel.isHidden = true
        default: print("어떤 텍스트 필드인지 모르겠습니다.")
        }
    }
}
