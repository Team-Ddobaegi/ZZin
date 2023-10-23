//
//  MatchingThumbnailCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit


//MARK: - 매칭 업체 리뷰 썸네일 :: TableView Cell

class MatchingThumbnailCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingThumbnailCell"
   
    private let review = ViewForReview().then{
        $0.wrap.layer.cornerRadius = 0
//        $0.underline.backgroundColor = .systemRed
        $0.underline.backgroundColor = ColorGuide.cherryTomato
    }
    
    
    //MARK: - Settings
    
    private func setView() {
       contentView.addSubview(review)
        
        configureUI()
    }
    
    private func configureUI(){
        review.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
