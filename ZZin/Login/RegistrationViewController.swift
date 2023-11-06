//
//  RegistrationViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    //MARK: - UIComponent 생성
    
    private let nicknameTextFieldView = CustomTextfieldView(placeholder: "", text: "닉네임", button: .cancelButton)
    private let emailTextFieldView = CustomTextfieldView(placeholder: "", text: "이메일", button: .noButton)
    private let doublecheckEmailFieldView = CustomTextfieldView(placeholder: "", text: "인증번호", button: .noButton)
    private let pwTextFieldView = CustomTextfieldView(placeholder: "", text: "비밀번호", button: .hideButton)
    private let doublecheckPwFieldView = CustomTextfieldView(placeholder: "", text: "재확인", button: .hideButton)
    private var locationPickerView: UIPickerView!
    private let locationList: [String] = ["서울", "경기도", "인천", "세종", "부산", "대전", "대구", "광주", "울산", "경북", "경남", "충남", "충북", "제주"]
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 2
    private var selectedRow = 0
    
    private var confirmButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.init(hexCode: "F55951")
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private let backbutton = UIButton().then {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
    }
    
    private let locationButton = UIButton().then {
        let image = UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setTitle("지역 설정하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(image, for: .normal)
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.cgColor
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.snp.makeConstraints {$0.height.equalTo(52)}
        $0.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private let infoLabel = UILabel().then {
        $0.text = "대문자로 시작되는 비밀번호를 작성해주세요"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .thin)
    }
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        [nicknameTextFieldView, emailTextFieldView].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        [doublecheckPwFieldView, locationButton].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
//    private let checkButton = UIButton().then {
//        $0.setTitle("중복", for: .normal)
//        $0.setTitleColor(.red, for: .normal)
//        $0.layer.cornerRadius = 12
//        $0.clipsToBounds = true
//        $0.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
//    }
    
    //MARK: - 메서드 생성
    func configure() {
        view.backgroundColor = .white
        [backbutton, topStackView, doublecheckEmailFieldView, pwTextFieldView, infoLabel, stackView, confirmButton].forEach { view.addSubview($0) }
    }
    
    private func setUI() {
        setBackButton()
        setTopStackView()
        // 에러시에만 실행
        setHidingEmailView()
        setPwTextView()
        setInfoLabel()
        setStackView()
        setConfirmButton()
//        setCheckButton()
    }
    
    private func setBackButton() {
        backbutton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
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
        doublecheckEmailFieldView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(353)
        }
    }
    
    private func setPwTextView() {
        if doublecheckEmailFieldView.isHidden {
            pwTextFieldView.snp.makeConstraints {
                $0.top.equalTo(topStackView.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(353)
            }
        } else {
            pwTextFieldView.snp.remakeConstraints {
                $0.top.equalTo(doublecheckEmailFieldView.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(353)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func setInfoLabel() {
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(pwTextFieldView.snp.bottom).offset(5)
            $0.leading.equalTo(pwTextFieldView.snp.leading).offset(5)
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
//            $0.centerY.equalTo(emailTextFieldView.snp.centerY)
//            $0.size.equalTo(CGSize(width: 50, height: 50))
//        }
//    }
    
    // 나타날 때와 사라질 때 각가 필요한 2개의 메서드
    private func setNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setDelegate() {
        emailTextFieldView.setTextFieldDelegate(delegate: self)
        pwTextFieldView.setTextFieldDelegate(delegate: self)
        nicknameTextFieldView.setTextFieldDelegate(delegate: self)
        doublecheckEmailFieldView.setTextFieldDelegate(delegate: self)
        doublecheckPwFieldView.setTextFieldDelegate(delegate: self)
    }
    
    private func displayView() {
        doublecheckEmailFieldView.isHidden = true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            self.view.frame.origin.y -= keyboardHeight
//        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(view.frame.origin.y)
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/2.5)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            self.view.frame.origin.y += keyboardHeight
//        }
        print(view.frame.origin.y)
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Auth 관련 함수
    private func checkIdPattern(_ email: String) -> Bool {
        guard !email.isEmpty else {
            emailTextFieldView.showInvalidMessage()
            showAlert(type: .idBlank)
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailpred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailpred.evaluate(with: email) else {
            emailTextFieldView.showInvalidMessage()
            showAlert(type: .firstTimeID)
            return false
        }
        return true
    }
    
    private func validPasswordPattern(_ password: String) -> Bool {
        guard !password.isEmpty else {
            pwTextFieldView.showInvalidMessage()
            showAlert(type: .passwordBlank)
            return false
        }
        
        let firstLetter = password.prefix(1)
        guard firstLetter == firstLetter.uppercased() else {
            print("첫 단어는 대문자가 필요합니다.")
            pwTextFieldView.showInvalidMessage()
            showAlert(type: .firstTimePass)
            return false
        }
        
        let numbers = password.suffix(1)
        guard numbers.rangeOfCharacter(from: .decimalDigits) != nil else {
            print("마지막은 숫자를 써주세요")
            pwTextFieldView.showInvalidMessage()
            showAlert(type: .firstTimeID)
            return false
        }
        return true
    }
    
    private func showAlert(type: ErrorHandling) {
        let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func confirmButtonTapped() {
        print("회원가입 버튼이 눌렸습니다.")
        
        guard let nickname = nicknameTextFieldView.textfield.text, !nickname.isEmpty else {
            nicknameTextFieldView.showInvalidMessage()
            showAlert(type: .doubleCheck)
            return
        }
        
        guard let id = emailTextFieldView.textfield.text, !id.isEmpty else {
            emailTextFieldView.showInvalidMessage()
            showAlert(type: .doubleCheck)
            return
        }
        
        guard let pw = pwTextFieldView.textfield.text, !pw.isEmpty else {
            showAlert(type: .doubleCheck)
            return
        }

        guard checkIdPattern(id) else {
            emailTextFieldView.showInvalidMessage()
            showAlert(type: .idError)
            return
        }
        
        guard validPasswordPattern(pw) else {
            pwTextFieldView.showInvalidMessage()
            showAlert(type: .passwordBlank)
            return
        }
        
        let credentials = AuthCredentials(email: id, password: pw, userName: nickname)
        AuthManager.shared.registerNewUser(with: credentials) { success, error in
            if success {
                print("유저가 생성되었습니다.")
                let mainVC = TabBarViewController()
                let testVC = CardController()
                testVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(mainVC, animated: true)
                self.present(testVC, animated: true)
            }
        }
//        AuthManager.shared.signInUser(with: id, password: pw) { success in
//            if success {
//                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                let nickName = self.nicknameTextFieldView.textfield.text
//                changeRequest?.displayName = nickName
//                
//                changeRequest?.commitChanges { error in
//                print(error)
//                }
//                
//                print("유저가 생성되었습니다.")
//                let vc = CardController()
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true)
//            } else {
//                print("계정이 이미 존재합니다.")
//                self.showAlert(type: .signInFailure)
//            }
//        }
    }
    
    @objc func backbuttonTapped() {
        print("되돌아가기 버튼이 눌렸습니다.")
        self.dismiss(animated: true)
    }
    
    @objc func locationButtonTapped() {
        print("지역 확인 버튼이 눌렸습니다.")
        
        // alertController로 지역 리스트 팝업
        let vc = ViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        vc.view.backgroundColor = .white
        let locationPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        locationPickerView.dataSource = self
        locationPickerView.delegate = self
        
        locationPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(locationPickerView)
        locationPickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        locationPickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "지역을 선택하세요", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = locationButton
        alert.popoverPresentationController?.sourceRect = locationButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "되돌아가기", style: .cancel, handler: { (UIAlertAction) in
        }))
        alert.addAction(UIAlertAction(title: "선택하기", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = locationPickerView.selectedRow(inComponent: 0)
            let selected = Array(self.locationList)[self.selectedRow]
            self.locationButton.setTitle(selected, for: .normal)
            self.locationButton.backgroundColor = .orange
        }))
        
        self.present(alert, animated: true)
    }
    
    deinit {
        print("Registration 화면이 내려갔습니다. \(#function)")
    }
}

// MARK: - LifeCycle 정리
extension RegistrationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegate()
        self.displayView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNotificationCenter()
        self.configure()
        self.setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotificationCenter()
    }
}

// MARK: - UITextFieldDelegate 선언
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.nicknameTextFieldView.textfield:
            nicknameTextFieldView.animateLabel()
            nicknameTextFieldView.textfield.placeholder = "나만의 닉넴은?"
        case self.emailTextFieldView.textfield:
            emailTextFieldView.animateLabel()
            emailTextFieldView.textfield.placeholder = "자주 쓰는 이메일이 있나요?"
        case self.pwTextFieldView.textfield:
            pwTextFieldView.animateLabel()
            pwTextFieldView.textfield.placeholder = "철통보안!"
        case self.doublecheckPwFieldView.textfield:
            doublecheckPwFieldView.animateLabel()
            doublecheckPwFieldView.textfield.placeholder = "다시 한번 입력해주세요"
        default: print("textfield를 찾지 못했습니다.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nicknameTextFieldView.textfield, let text = textField.text, text.isEmpty {
            nicknameTextFieldView.undoLabelAnimation()
        } else if textField == emailTextFieldView.textfield, let text = textField.text, text.isEmpty {
            emailTextFieldView.undoLabelAnimation()
        } else if textField == pwTextFieldView.textfield, let text = textField.text, text.isEmpty {
            pwTextFieldView.undoLabelAnimation()
        } else if textField == doublecheckPwFieldView.textfield, let text = textField.text, text.isEmpty {
            doublecheckPwFieldView.undoLabelAnimation()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToTextfield(textField)
        return true
    }
    
    private func switchToTextfield(_ textField: UITextField) {
        switch textField {
        case self.nicknameTextFieldView.textfield:
            self.pwTextFieldView.textfield.becomeFirstResponder()
        case self.emailTextFieldView.textfield:
            self.nicknameTextFieldView.textfield.becomeFirstResponder()
        case self.pwTextFieldView.textfield:
            self.pwTextFieldView.textfield.resignFirstResponder()
        case self.doublecheckPwFieldView.textfield:
            self.doublecheckPwFieldView.textfield.resignFirstResponder()
        default:
            self.doublecheckPwFieldView.textfield.resignFirstResponder()
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource 선언
extension RegistrationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(locationList)[row]
        label.sizeToFit()
        return label
    }
}

extension RegistrationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}
