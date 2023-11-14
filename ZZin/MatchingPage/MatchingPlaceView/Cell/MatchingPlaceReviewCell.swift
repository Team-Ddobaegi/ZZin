//
//  MatchingPlaceReviewCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit
import Then


//MARK: - 매칭 업체 방문자 리뷰가 나올 TableView Cell

class MatchingPlaceReviewCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Settings
    
    private func setView(){
        backgroundColor = .customBackground
        configureUI()
    }
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingPlaceReviewCell"
    
    let recommendPlaceReview = RecommendPlaceReviewThumbnail().then{
        $0.regionLabel.text = ""
        $0.underline.backgroundColor = .clear
        $0.reviewTitleLabel.font = .systemFont(ofSize: 22,  weight: .bold)
        $0.withKeywordLabel.font = .systemFont(ofSize: 13, weight: .light)
        $0.conditionKeywordLabel.font = .systemFont(ofSize: 13, weight: .light)
    }
    
    
    //MARK: - ConfigureUI
    
    private func configureUI(){
        contentView.addSubview(recommendPlaceReview)
        
        recommendPlaceReview.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(210)
        }
    }
}
