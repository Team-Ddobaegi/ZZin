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

    var customView = RecommendPlaceReviewThumbnail()
    
    var trashButton = UIButton().then{
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = .white
    }
    
    var editButton = UIButton().then{
        $0.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        $0.tintColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        customView.layer.cornerRadius = 15
        customView.regionLabel.isHidden = true
        
        customView.img.image = UIImage(named: "AppIcon")
        customView.reviewTitleLabel.text = "아직 작성한 리뷰가 없어요!"
        customView.withKeywordLabel.text = "# 첫 리뷰"
        customView.conditionKeywordLabel.text = "# 작성하러 가기"
        trashButton.isHidden = true
        editButton.isHidden = true
        
        addSubview(customView)
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(trashButton)
        trashButton.snp.makeConstraints{
            $0.top.right.equalToSuperview().inset(16)
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        contentView.addSubview(editButton)
        editButton.snp.makeConstraints{
            $0.top.equalTo(trashButton.snp.top)
            $0.right.equalTo(trashButton.snp.left).offset(-16)
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        
    }
    
    
}
