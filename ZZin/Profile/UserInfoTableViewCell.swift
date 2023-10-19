//
//  UserInfoTableViewCell.swift
//  ZZin
//
//  Created by 보경 on 10/15/23.
//

import UIKit
import SnapKit
import Then

class UserInfoTableViewCell: UITableViewCell {
    static let identifier = "UserInfoTableViewCell"
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profile") // 추후 업로드 방식으로 변경 필요
        $0.layer.cornerRadius = 85/2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.clipsToBounds = true
    }
    
    let nickname = UILabel().then {
        $0.text = "맛있으면우는냥" // 추후 변경 닉네임 적용 필요
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let designationWrap = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .systemGroupedBackground
    }
    
    let designationTitle = UILabel().then {
        $0.text = "😎노포마스터" // 추후 칭호 변경 적용 필요
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAutoLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAutoLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 85, height: 85))
        }
        
        contentView.addSubview(nickname)
        nickname.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(6)
        }
        
        contentView.addSubview(designationWrap)
        designationWrap.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nickname.snp.bottom).offset(6)
            $0.size.equalTo(CGSize(width: 100, height: 35))
        }
        designationWrap.addSubview(designationTitle)
        designationTitle.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }

}
