//
//  userSearchController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/19.
//

import UIKit
import SnapKit
import Then

// MARK: - UIComponent 선언
class UserSearchController: UIViewController {
    
    private let idTextfieldView = CustomTextfieldView(placeholder: "닉네임을 입력해주세요", text: "")
    private let numberTextfieldView = CustomTextfieldView(placeholder: "- 없이 입력해주세요", text: "")
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "전화번호"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
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
        [idLabel, numberLabel, idTextfieldView, numberTextfieldView, confirmButton].forEach{view.addSubview($0)}
        setUI()
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

extension UserSearchController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
