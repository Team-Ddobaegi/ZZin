//
//  RegistrationViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit
import Then
//import FirebaseAuth
//import Firebase

class RegistrationViewController: UIViewController {
    
    private lazy var idTextfieldView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(idTextField)
        $0.addSubview(idInfoLabel)
        $0.addSubview(doubleCheckButton)
    }
    
    private var idInfoLabel = UILabel().then {
        $0.text = "아이디를 입력해 주세요"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var idTextField = UITextField().then {
        $0.textColor = .white
        $0.keyboardType = .default
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var pwTextfieldView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(pwTextField)
        $0.addSubview(pwInfoLabel)
    }
    
    private var pwInfoLabel = UILabel().then {
        $0.text = "비밀번호를 입력해 주세요"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var pwTextField = UITextField().then {
        $0.textColor = .white
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.keyboardType = .default
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var checkPwTextfieldView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(checkPwTextField)
        $0.addSubview(checkPwInfoLabel)
    }
    
    private var checkPwInfoLabel = UILabel().then {
        $0.text = "한번만 더 입력해 주세요"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var checkPwTextField = UITextField().then {
        $0.textColor = .white
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.keyboardType = .default
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var nicknameTextfieldView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(nicknameTextField)
        $0.addSubview(nicknameInfoLabel)
        $0.addSubview(doubleCheckButton)
    }
    
    private var nicknameInfoLabel = UILabel().then {
        $0.text = "닉네임을 입력해 주세요"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var nicknameTextField = UITextField().then {
        $0.textColor = .white
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.keyboardType = .default
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var numberTextfieldView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(numberTextField)
        $0.addSubview(numberInfoLabel)
    }
    
    private var numberInfoLabel = UILabel().then {
        $0.text = "전화 번호를 입력해주세요"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var numberTextField = UITextField().then {
        $0.textColor = .white
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.keyboardType = .default
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var doubleCheckButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(doubleCheckButtonTapped), for: .touchUpInside)
    }
    
    private var confirmButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .red
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func configure() {
        view.backgroundColor = .white
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
        if idTextField.text?.isEmpty == true || pwTextField.text?.isEmpty == true || nicknameTextField.text?.isEmpty == true {
            print("비어있는 값이 있는지 확인해주세요.")
            return("비어있는 값이 있는지 확인해주세요.")
        }
        // 비밀번호가 안전한지 확인 - 8자 이상, 대문자 / 소문자 / 숫자 조합인지 확인
        let checkedPassword = pwTextField.text!
        if AuthService.shared.validatePassword(checkedPassword) == false {
            print("비밀번호가 8자 이상, 숫자와 특수문자가 최소 1개씩 들어갔는지 확인해주세요!")
            return "비밀번호가 8자 이상, 숫자와 특수문자가 최소 1개씩 들어갔는지 확인해주세요!"
        }
        return nil
    }
    
    // 여기서 문제점은 한 버튼에 모든 역할을 부여했기에 코드를 이해하는데 발생하는 이슈
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
            
            //            AuthService.shared.registerUser(with: checked, completion: <#T##(Bool, Error?) -> Void#>)
            
            //            // 유저 생성 - Firebase가 가지고 있는 함수를 활용해서 사용자 생성
            //            Auth.auth().createUser(withEmail: checkedId, password: checkedPassword) { result, error in
            //                guard let error = error else { print("에러가 발생했습니다. - \(error?.localizedDescription)"); return }
            //                // 유저가 에러 없었다! 생성이 되야 한다는 점
            //                let db = Firestore.firestore()
            //                db.collection("users").addDocument(data: ["id": checkedId, "password": checkedPassword, "uid": result?.user.uid]) { error in
            //                    // 이 단계에서 데이터 저장 관련 에러를 확인하는 과정을 거치는게 맞나? >> error != nil이 맞나?
            //                    if error != nil {
            //                        print("저장하는데 에러가 발생했습니다.")
            //                    }
            //                }
            //            }
            //            print("회원가입이 완료되었습니다.")
            //            let vc = LoginViewController()
            //            vc.modalPresentationStyle = .fullScreen
            //            self.present(vc, animated: true)
            //        }
            //        // 화면 전환
            //        self.dismiss(animated: true)
        }
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
        // label을 위로 옮기는 역할하기 이전 먼저 숨기도록 처리 - Test 형식
        switch textField {
        case idTextField: idInfoLabel.isHidden = true
        case pwTextField: pwInfoLabel.isHidden = true
        case checkPwTextField: checkPwInfoLabel.isHidden = true
        case nicknameTextField: nicknameInfoLabel.isHidden = true
        case numberTextField: numberInfoLabel.isHidden = true
        default: print("텍스트 필드를 찾을 수 없습니다.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextField {
            idInfoLabel.isHidden = !textField.text!.isEmpty
        } else if textField == pwTextField {
            pwInfoLabel.isHidden = !textField.text!.isEmpty
        } else if textField == checkPwTextField {
            checkPwInfoLabel.isHidden = !textField.text!.isEmpty
        } else if textField == nicknameTextField {
            nicknameInfoLabel.isHidden = !textField.text!.isEmpty
        } else if textField == numberTextField {
            numberInfoLabel.isHidden = !textField.text!.isEmpty
        }
    }
}
