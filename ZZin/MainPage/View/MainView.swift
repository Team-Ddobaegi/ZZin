//
//  MainView.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

class MainView: UIView {    
    //MARK: - 로고 선정 이후 이미지 적용 필요🚨
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.register(LocalTableViewCell.self, forCellReuseIdentifier: LocalTableViewCell.identifier)
        $0.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        $0.register(MainHeaderView.self, forHeaderFooterViewReuseIdentifier: MainHeaderView.identifier)
    }
    
    private let logoView = UIImageView().then {
        let image = UIImage(named: "MainIcon")
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.backgroundColor = .customBackground
        self.backgroundColor = .customBackground
        setTableView()
        setLogo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("오류가 발생했습니다.")
    }
    
    func setTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func setLogo() {
        addSubview(logoView)
        logoView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(50)
            $0.size.equalTo(CGSize(width: 48, height: 48))
        }
    }
}
