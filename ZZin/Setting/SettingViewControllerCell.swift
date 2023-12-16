//
//  SettingViewControllerCell.swift
//  ZZin
//
//  Created by clone1 on 2023/11/03.
//

import UIKit
import SnapKit
import Then


 class SettingViewControllerCell: UITableViewCell {
    
        static let identifier = "SettingViewControllerCell"
     
     var leadingImage = UIImageView().then {
         $0.tintColor = .label
         $0.contentMode = .scaleAspectFit
     }
     
     var text = UILabel().then {
         $0.font = .systemFont(ofSize: 18, weight: .regular)
         $0.textColor = .label
     }
     
     var trailingImage = UIImageView().then {
         $0.tintColor = .systemGray4
         $0.image = UIImage(systemName: "chevron.forward")
         $0.contentMode = .scaleAspectFit
     }
     
     var appVersionText = UILabel().then {
         $0.text = "1.0.1"
         $0.font = .systemFont(ofSize: 12, weight: .semibold)
         $0.textColor = .systemGray
     }
         
     override init(style: SettingViewControllerCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         setupUI()
     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been impl")
     }
     
     func setupUI() {
         backgroundColor = .customBackground
         addSubview(leadingImage)
         addSubview(text)
         addSubview(trailingImage)
         addSubview(appVersionText)
         
         leadingImage.snp.makeConstraints {
             $0.centerY.equalToSuperview()
             $0.leading.equalToSuperview().offset(20)
             $0.trailing.equalTo(text.snp.leading).inset(-20)
             $0.width.height.equalTo(40)
         }
         
         text.snp.makeConstraints {
             $0.centerY.equalToSuperview()
             $0.leading.equalTo(leadingImage.snp.trailing)
         }

         trailingImage.snp.makeConstraints {
             $0.centerY.equalToSuperview()
             $0.trailing.equalToSuperview().offset(-10)
             $0.width.height.equalTo(50)
             $0.height.equalTo(25)
         }
         
         appVersionText.snp.makeConstraints {
             $0.centerY.equalToSuperview()
             $0.trailing.equalToSuperview().offset(-10)
             $0.width.equalTo(50)
         }
     }
 }
