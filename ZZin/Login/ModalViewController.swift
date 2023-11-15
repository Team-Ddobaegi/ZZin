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
    
    private let noticeLabel = UILabel().then {
        $0.text = "당신의 찐 ID를 찾았어요!"
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    private var userInfoLabel = UILabel().then {
        $0.text = "테스트 명칭"
        $0.font = UIFont.systemFont(ofSize: 40, weight: .bold)
    }
    
    private let endNoticeLabel = UILabel().then {
        $0.text = "입니다"
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
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
    
    private let confirmButton = UIButton().then {
            $0.backgroundColor = .white
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        }
    
    func configure() {
        [noticeStackView, confirmButton].forEach{view.addSubview($0)}
        view.backgroundColor = ColorGuide.main
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
