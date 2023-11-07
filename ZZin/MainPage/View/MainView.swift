//
//  MainView.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

protocol MainViewDelegate: AnyObject {
    func didTapLogout()
}

class MainView: UIView {
    weak var delegate: MainViewDelegate?
    
    //MARK: - 로고 선정 이후 이미지 적용 필요🚨
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.register(LocalTableViewCell.self, forCellReuseIdentifier: LocalTableViewCell.identifier)
        $0.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        $0.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        $0.register(MainHeaderView.self, forHeaderFooterViewReuseIdentifier: MainHeaderView.identifier)
    }
    
    private let logOutButton = UIButton().then {
        $0.setTitle("로그아웃하기", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.backgroundColor = .white
        setTableView()
        setLogOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("오류가 발생했습니다.")
    }
    
    func setTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setLogOut() {
        addSubview(logOutButton)
        logOutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    @objc func logOutTapped() {
        delegate?.didTapLogout()
    }
}
