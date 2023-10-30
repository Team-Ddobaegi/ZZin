//
//  CustomTextfieldView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/24.
//

import UIKit
import SnapKit
import Then

class CustomTextfieldView: UIView {
    
    enum ButtonType {
        case cancelButton
        case hideButton
        case doubleCheckButton
    }
    
    private var animatingLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var textfield = UITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.keyboardType = .default
    }
    
    private let validationLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        $0.textColor = UIColor.init(hexCode: "F55951")
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }

    private let cancelButton = UIButton().then {
        let image = UIImage(systemName: "x.circle")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imageView?.tintColor = .systemGray
        $0.isHidden = true
        $0.setImage(image, for: .normal)
        $0.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    private let secureButton = UIButton().then {
        let image = UIImage(systemName: "eye")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "eye.slash")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.setImage(selectedImage, for: .normal)
        $0.setImage(image, for: .selected)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(secureButtonTapped), for: .touchUpInside)
    }
    
    private let doubleCheckButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("중복 체크", for: .normal)
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(doubleCheckButtonTapped), for: .touchUpInside)
    }

    init(placeholder: String, text: String) {
        super.init(frame: .zero)
        textfield.placeholder = placeholder
        animatingLabel.text = text
        
        configure()
        setUI()
        commonInit()
    }
    
    init(placeholder: String, text: String, alertMessage: String? = "다시 확인해주세요", button: ButtonType) {
        super.init(frame: .zero)
        textfield.placeholder = placeholder
        animatingLabel.text = text
        validationLabel.text = alertMessage
                
        configure()
        setUI()
        commonInit()
        
        switch button {
        case .cancelButton: addCancelButton()
        case .hideButton: addEyeButton()
        case .doubleCheckButton: addDoubleCheckButton()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
}

extension CustomTextfieldView {
    private func configure() {
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 12
        [animatingLabel, textfield, validationLabel].forEach{ addSubview($0) }
    }

    private func setUI() {
        animatingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        
        validationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().inset(5)
        }

        textfield.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(5)
        }
    }
    
    private func addEyeButton() {
        addSubview(secureButton)
        secureButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
            $0.height.width.equalTo(30)
        }
    }
    
    private func addCancelButton() {
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
            $0.height.width.equalTo(30)
        }
    }
    
    private func addDoubleCheckButton() {
        addSubview(doubleCheckButton)
        doubleCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
            $0.height.width.equalTo(30)
        }
    }
    
    private func commonInit() {
        backgroundColor = .gray
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        textfield.delegate = delegate
    }
    
    // MARK: - Animation
    // Label Animation 적용
    func animateLabel() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0) {
            self.backgroundColor = .white
            self.animatingLabel.textColor = .green
            self.layer.borderWidth = 1
            self.layer.borderColor = self.animatingLabel.textColor.cgColor

            //Animation 적용시 이동 범위
            let movement = CGAffineTransform(translationX: -8, y: -24)
            let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.animatingLabel.transform = movement.concatenating(scale)

        //Animation 이후 행동
        } completion: { position in
            self.textfield.isHidden = false
            self.textfield.becomeFirstResponder()
            
            self.cancelButton.isHidden = false
        }
    }
    
    // Label Animation을 되돌리는 함수
    func undoLabelAnimation() {
        let movement = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            self.backgroundColor = .systemGray5
            self.animatingLabel.textColor = .systemGray
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor

            // visibility
            self.textfield.text = ""
            self.textfield.isHidden = true
            self.cancelButton.isHidden = true

            // movement
            self.animatingLabel.transform = .identity
        }
        movement.startAnimation()
    }
    
    func showInvalidMessage() {
        self.validationLabel.isHidden = false
        self.animatingLabel.isHidden = true
        self.layer.borderColor = UIColor.init(hexCode: "F55951").cgColor
        self.textfield.tintColor = UIColor.init(hexCode: "F55951")
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            print("탭이 눌렸습니다.")
            animateLabel()
        }
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        textfield.resignFirstResponder()
        undoLabelAnimation()
    }
    
    @objc func secureButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            textfield.isSecureTextEntry = false
            print("숨겨진 비밀번호가 해제됐습니다.")
        } else {
            textfield.isSecureTextEntry = true
            print("비밀번호가 숨겨졌습니다.")
        }
    }
    
    @objc func doubleCheckButtonTapped(_ sender: UIButton) {
        print("중복 검사를 진행합니다.")
    }
}
