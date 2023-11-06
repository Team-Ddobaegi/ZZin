//
//  RecommendedPlaceCell.swift
//  ZZin
//
//  Created by 남보경 on 2023/10/29.
//

import UIKit
import SnapKit
import Then

class RecommendedPlaceCell: UICollectionViewCell {
    static let identifier = "RecommendedPlaceCell"

    var customView = RecommendPlaceThumbnail()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        customView.layer.cornerRadius = 15
        contentView.addSubview(customView)
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

