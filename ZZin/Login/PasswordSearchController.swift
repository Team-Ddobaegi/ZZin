//
//  PasswordSearchController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/27.
//

import UIKit
import SnapKit
import Then

// MARK: - UIComponent 선언
class PasswordSearchController: UIViewController {
    
    private let idTextfieldView = CustomTextfieldView(placeholder: "", text: "적어주세요", alertMessage: "", button: .noButton)
    private let numberTextfieldView = CustomTextfieldView(placeholder: "", text: "적어주세요")
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "전화번호"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(hexCode: "F55951")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()

    
    // MARK: - 함수 선언
    private func configure() {
        view.backgroundColor = .white
        [idLabel, idTextfieldView, numberLabel, numberTextfieldView, confirmButton].forEach{view.addSubview($0)}
    }
    
    private func setUI() {
        idLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(49)
            $0.top.equalToSuperview().offset(305)
            $0.size.equalTo(CGSize(width: 56, height: 24))
        }
        
        idTextfieldView.snp.makeConstraints {
            $0.centerY.equalTo(idLabel.snp.centerY)
            $0.leading.equalTo(idLabel.snp.trailing).offset(23)
            $0.size.equalTo(CGSize(width: 208, height: 52))
        }
        
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(49)
            $0.top.equalTo(idLabel.snp.bottom).offset(88)
            $0.size.equalTo(CGSize(width: 74, height: 24))
        }
        
        numberTextfieldView.snp.makeConstraints {
            $0.centerY.equalTo(numberLabel.snp.centerY)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(5)
            $0.size.equalTo(CGSize(width: 208, height: 52))
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(numberTextfieldView.snp.bottom).offset(233)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 223, height: 60))
        }
    }
    
    private func setDelegate() {
            idTextfieldView.setTextFieldDelegate(delegate: self)
            numberTextfieldView.setTextFieldDelegate(delegate: self)
    }
    
    @objc func confirmButtonTapped() {
        print("확인 버튼이 눌렸습니다.")
        let vc = ModalViewController()
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(vc, animated: true)
    }
    
    deinit {
        print("\(#function) - UserSearchController가 내려갔습니다.")
    }
}

extension PasswordSearchController {
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

extension PasswordSearchController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.idTextfieldView.textfield:
            idTextfieldView.animateLabel()
            idTextfieldView.textfield.placeholder = "닉네임을 적어주세요"
        case self.numberTextfieldView.textfield:
            numberTextfieldView.animateLabel()
            numberTextfieldView.textfield.placeholder = "전화번호를 적어주세요"
        default: print("textfield를 찾지 못했습니다.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextfieldView.textfield, let text = textField.text, text.isEmpty {
            idTextfieldView.undoLabelAnimation()
        } else if textField == numberTextfieldView.textfield, let text = textField.text, text.isEmpty {
            numberTextfieldView.undoLabelAnimation()
        }
    }
}
