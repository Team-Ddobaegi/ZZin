//
//  ReviewCell.swift
//  ZZin
//
//  Created by 남보경 on 2023/10/29.
//

import UIKit
import Then
import SnapKit

class ReviewCell: UICollectionViewCell {
    static let identifier = "ReviewCell"

    var customView = ViewForReview()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(customView)
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
