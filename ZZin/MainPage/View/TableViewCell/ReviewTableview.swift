//
//  ReviewTableview.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/16.
//

import UIKit

class ReviewTableviewCell: UITableViewCell {
    static let identifier: String = "ReviewTableviewCell"
    
    let placeReview = RecommendPlaceReviewThumbnail().then{
        $0.regionLabel.text = ""
        $0.underline.backgroundColor = .clear
        $0.reviewTitleLabel.font = .systemFont(ofSize: 22,  weight: .bold)
        $0.withKeywordLabel.font = .systemFont(ofSize: 13, weight: .light)
        $0.conditionKeywordLabel.font = .systemFont(ofSize: 13, weight: .light)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(){
        backgroundColor = .customBackground
        configure()
    }
    
    private func configure(){
        contentView.addSubview(placeReview)
        
        placeReview.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(230)
        }
    }
}
