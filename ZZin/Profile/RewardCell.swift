//
//  RewardCell.swift
//  ZZin
//
//  Created by 남보경 on 2023/10/29.
//

import UIKit
import Then
import SnapKit

class RewardCell: UICollectionViewCell {
    static let identifier = "RewardCell"

    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        
        contentView.layer.borderColor = ColorGuide.main.cgColor
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        addSubview(imageView)
        addSubview(titleLabel)

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: contentView.bounds.width * 0.6, height:  contentView.bounds.width * 0.6))
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
