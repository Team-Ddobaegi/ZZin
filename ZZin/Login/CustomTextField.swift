//
//  CustomTextField.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/16.
//

import UIKit
import SnapKit

class CustomTextFieldView: UIView {
    private lazy var textfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .blue
        tf.textColor = .white
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    convenience init(text: String) {
        self.init(frame: .zero)
        configure()
        setUI()
        infoLabel.text = text
    }
    
    private func configure() {
        addSubview(textfieldView)
        textfieldView.addSubview(infoLabel)
        textfieldView.addSubview(textField)
    }
    
    private func setUI() {
        textfieldView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }
}
