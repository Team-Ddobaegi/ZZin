//
//  ProfileHeader.swift
//  ZZin
//
//  Created by 남보경 on 2023/10/29.
//

import UIKit
import Then
import SnapKit

class ProfileCell: UICollectionViewCell {
    static let identifier = "ProfileCell"

    var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 85 / 2
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ColorGuide.main.cgColor
        $0.backgroundColor = .systemGray4  // 예시 색상
    }

    var usernameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.text = "유저닉네임"
        $0.textColor = .label
    }

    let editProfileButton = UIButton().then {
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 12
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.tintColor = .white
    }

    var grayFilledButton = UIButton().then {
        $0.backgroundColor =  .systemGroupedBackground
        $0.setTitle("  💛우리동네 찐친  ", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.layer.cornerRadius = 12
    }

    // TODO: 맛집 추천 수/리뷰수/팔로워/ 팔로잉 수를 표시하는 뷰들 추가

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [profileImageView, usernameLabel, editProfileButton, grayFilledButton].forEach {
            addSubview($0)
        }

        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(85)
        }

        usernameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(6)
        }

        editProfileButton.snp.makeConstraints {
            $0.left.equalTo(usernameLabel.snp.right).offset(6)
            $0.centerY.equalTo(usernameLabel)
            $0.width.height.equalTo(24)
        }

        grayFilledButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(usernameLabel.snp.bottom).offset(6)
            $0.height.equalTo(28)
        }

        // TODO: 맛집 추천 수/리뷰수/팔로워/ 팔로잉 수에 대한 레이아웃 설정
    }
}
