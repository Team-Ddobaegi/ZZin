//
//  detailRegistrationViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/20.
//

import UIKit
import SnapKit
import Then

class DetailRegistrationViewController: UIViewController {
    var dummyTitle: [String] = ["전국", "서울", "경기도", "인천", "세종", "부산", "대전", "대구", "광주", "울산", "경북", "경남", "충남", "충북", "제주"]
    
    private let noticeLabel = UILabel().then {
        $0.text = "찐 궁금한 지역이 어딘가요?"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private lazy var regionSelectTableView = UITableView(frame: .zero, style: .plain).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.register(DetailRegistrationCell.self, forCellReuseIdentifier: DetailRegistrationCell.reuseIdentifer)
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func configure() {
        [noticeLabel, regionSelectTableView, confirmButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
        regionSelectTableView.separatorStyle = .none
        setUI()
    }
    
    func setUI() {
        noticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(142)
        }
        
        regionSelectTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(noticeLabel.snp.bottom).offset(16)
            $0.height.equalTo(565)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(regionSelectTableView.snp.bottom)
            $0.size.equalTo(CGSize(width: 353, height: 52))
        }
    }
    
    @objc func confirmButtonTapped() {
        print("다음 버튼이 눌렸습니다.")
        let vc = CardController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension DetailRegistrationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension DetailRegistrationViewController: UITableViewDelegate {
    
}

extension DetailRegistrationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailRegistrationCell.reuseIdentifer, for: indexPath) as! DetailRegistrationCell
        cell.setTitle(text: dummyTitle[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
}
