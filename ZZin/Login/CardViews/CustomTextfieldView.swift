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
    
    let animatingLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.text = "테스트 값"
    }
    
    let textfield = UITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .systemGreen
        $0.placeholder = "텍스트 값"
    }
    
    let cancleButton = UIButton().then {
        let image = UIImage(systemName: "x.square.fill")
        $0.setImage(image, for: .normal)
        $0.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
}

extension CustomTextfieldView {
    func configure() {
        textfield.delegate = self
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray5
        layer.cornerRadius = 12
        [animatingLabel, textfield].forEach{ addSubview($0) }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        addGestureRecognizer(tap)
    }
    
    func setUI() {
        animatingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        
        textfield.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    func labelAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0) {
            // color
            self.backgroundColor = .white
            self.animatingLabel.textColor = .green
            self.layer.borderWidth = 1
            self.layer.borderColor = self.animatingLabel.textColor.cgColor
            
            //movement
            let movement = CGAffineTransform(translationX: -8, y: -24)
            let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.animatingLabel.transform = movement.concatenating(scale)
            
        // 추가 활동
        } completion: { position in
            self.textfield.isHidden = false
            self.textfield.becomeFirstResponder()
        }
    }
    
    func undo() {
        let movement = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            self.backgroundColor = .systemGray5
            self.animatingLabel.textColor = .systemGray
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
            
            // visibility
            self.textfield.isHidden = true
            self.textfield.text = ""
            
            // movement
            self.animatingLabel.transform = .identity
        }
        movement.startAnimation()
    }
    
    @objc func labelTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            print("탭이 종료되었습니다.")
            labelAnimation()
        }
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        textfield.resignFirstResponder()
        undo()
    }
}

extension CustomTextfieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        return false
    }
    
    // email Validation 진행 가능
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
