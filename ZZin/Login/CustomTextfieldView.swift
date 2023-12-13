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
        case noButton
        case cancelButton
        case hideButton
        case checkButton
        case crossCheckButton
    }
    
    private var animatingLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 15)
    }

    lazy var textfield = UITextField().then {
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.keyboardType = .default
        $0.textColor = .black
    }
    
    private let validationLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = ColorGuide.main
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }

    private let cancelButton = UIButton().then {
        let image = UIImage(systemName: "x.circle")
        $0.imageView?.tintColor = .systemGray
        $0.isHidden = true
        $0.setImage(image, for: .normal)
        $0.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    private let checkButton = UIButton().then {
        let image = UIImage(systemName: "checkmark.circle")
        $0.imageView?.tintColor = .black
        $0.isHidden = false
        $0.setImage(image, for: .normal)
        $0.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    private let crossCheckButton = UIButton().then {
        $0.setTitle("인증하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(doubleCheckTapped), for: .touchUpInside)
    }

    private let secureButton = UIButton().then {
        let image = UIImage(systemName: "eye")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "eye.slash")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        $0.setImage(selectedImage, for: .normal)
        $0.setImage(image, for: .selected)
    }
    
    var buttonAction: (() -> Void)?

    init(placeholder: String, text: String) {
        super.init(frame: .zero)
        textfield.placeholder = placeholder
        animatingLabel.text = text
        
        configure()
        setUI()
        commonInit()
    }
    
    // convenience Initializer!!!
    init(placeholder: String, text: String, alertMessage: String, button: ButtonType) {
        super.init(frame: .zero)
        textfield.placeholder = placeholder
        animatingLabel.text = text
        validationLabel.text = alertMessage
        
        configure()
        setUI()
        commonInit()
        
        switch button {
        case .noButton: print("no button")
        case .cancelButton: addCancelButton()
        case .hideButton: addEyeButton()
        case .checkButton: addCheckButton()
        case .crossCheckButton: addCrossCheckButton()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        secureButton.addTarget(self, action: #selector(secureButtonTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 55)
    }
}

extension CustomTextfieldView {
    private func configure() {
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        [animatingLabel, textfield, validationLabel].forEach{ addSubview($0) }
    }
    
    private func setUI() {
        animatingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        validationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().inset(10)
        }
        
        textfield.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().inset(10)
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
    
    private func addCheckButton() {
        addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
            $0.height.width.equalTo(30)
        }
    }
    
    private func addCrossCheckButton() {
        addSubview(crossCheckButton)
        crossCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        }
    }
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        textfield.delegate = delegate
    }
    
    func setNewImage(_ image: UIImage?) {
        checkButton.setImage(image, for: .normal)
    }
    
    func updateUI() {
        crossCheckButton.setTitle("", for: .normal)
    }
    
    // MARK: - Animation
    // Label Animation 적용
    func animateLabel() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0) {
            self.backgroundColor = .white
            self.animatingLabel.textColor = .gray
//            self.layer.borderWidth = 1
            self.layer.borderColor = self.animatingLabel.textColor.cgColor

            //Animation 적용시 이동 범위
            let movement = CGAffineTransform(translationX: -9, y: -20)
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
            self.backgroundColor = .white
            self.animatingLabel.textColor = .gray
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.lightGray.cgColor

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
        self.layer.borderColor = ColorGuide.main.cgColor
        self.textfield.tintColor = ColorGuide.main
    }
    
    func hideInvalideMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.validationLabel.isHidden = true
            self.animatingLabel.isHidden = false
        })
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            print("탭이 눌렸습니다.")
            animateLabel()
        }
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        self.textfield.text = ""
        textfield.resignFirstResponder()
        undoLabelAnimation()
    }
    
    @objc func checkButtonTapped() {
        buttonAction?()
    }
    
    @objc func doubleCheckTapped() {
        buttonAction?()
    }
    
    @objc func secureButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.textfield.isSecureTextEntry = false
            print("숨겨진 비밀번호가 해제됐습니다.")
        } else {
            self.textfield.isSecureTextEntry = true
            print("비밀번호가 숨겨졌습니다.")
        }
    }
}
