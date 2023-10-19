//
//  ModalViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/19.
//

import UIKit
import SnapKit
import Then

class ModalViewController: UIViewController {
    var userID: String?
    var password: String?
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "당신의 찐 ID를 찾았어요!"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var userInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트 명칭"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private let endNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = "입니다"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var noticeStackView: UIStackView = {
        let stackView = UIStackView()
        [noticeLabel, userInfoLabel, endNoticeLabel].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func configure() {
        [noticeStackView, confirmButton].forEach{view.addSubview($0)}
        view.backgroundColor = .red
        setUI()
    }
    
    func setUI() {
        noticeStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(62)
            $0.width.equalTo(281)
            $0.height.equalTo(136)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noticeStackView.snp.bottom).offset(32)
            $0.width.equalTo(223)
            $0.height.equalTo(60)
        }
    }
    
    @objc func confirmButtonTapped() {
        print("내 정보를 찾았습니다.")
//        self.presentedViewController?.dismiss(animated: true, completion: {
//            self.presentingViewController?.dismiss(animated: true)
//        })
        let presentingViewController = self.presentingViewController
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    deinit {
        print("\(#function) - ModalViewController가 내려갔습니다.")
    }
}

extension ModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
