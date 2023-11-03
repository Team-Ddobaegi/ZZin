//
//  ButtonTableViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/03.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    static let identifier = "ButtonTableViewCell"
    
    let topRankButton = CustomButton(title: "1위", img: "대갈")
    let secondRankButton = CustomButton(title: "2위", img: "마리오")
    let thirdRankButton = CustomButton(title: "3위", img: "바위파스타")
    let fourthRankButton = CustomButton(title: "4위", img: "소감")
    let fifthRankButton = CustomButton(title: "5위", img: "송계옥")
    let sixthRankButton = CustomButton(title: "6위", img: "멘쇼")
    
    private lazy var topRankStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topRankButton, secondRankButton, thirdRankButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 19
        return stackView
    }()
    
    private lazy var follwupRankStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fourthRankButton, fifthRankButton, sixthRankButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 19
        return stackView
    }()
    
    private lazy var rankButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topRankStackView, follwupRankStackView])
        stackView.axis = .vertical
//        stackView.alignment = .
        stackView.spacing = 10
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(rankButtonStackView)
        rankButtonStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
