//
//  userSearchController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/19.
//

import UIKit
import SnapKit
import Then

class UserSearchController: UIViewController {
    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var idTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(idTextField)
        view.addSubview(idPlaceholder)
        return view
    }()
    
    private var idPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해 주세요"
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
    
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "전화번호"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var numberTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(numberTextField)
        view.addSubview(numberPlaceholder)
        return view
    }()
    
    private var numberPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "- 없이 입력해주세요"
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
    
    private var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private func configure() {
        view.backgroundColor = .white
        [idLabel, numberLabel, idTextfieldView, numberTextfieldView, confirmButton].forEach{view.addSubview($0)}
    }
    
    private func setUI() {
        idLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(49)
            $0.top.equalToSuperview().offset(305)
        }
        
        idTextfieldView.snp.makeConstraints {
            $0.centerY.equalTo(idLabel.snp.centerY)
            $0.leading.equalTo(idLabel.snp.trailing).offset(23)
            $0.width.equalTo(208)
            $0.height.equalTo(43)
        }
        
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(49)
            $0.top.equalTo(idLabel.snp.bottom).offset(88)
        }
        
        numberTextfieldView.snp.makeConstraints {
            $0.centerY.equalTo(numberLabel.snp.centerY)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(5)
            $0.width.equalTo(208)
            $0.height.equalTo(43)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(numberTextfieldView.snp.bottom).offset(233)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(223)
            $0.height.equalTo(60)
        }
    }
    
    @objc func confirmButtonTapped() {
        print("확인 버튼이 눌렸습니다.")
    }
}

extension UserSearchController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUI()
    }
}
