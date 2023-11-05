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
    
    
    // MARK: - Settings
    
    private func setView(){
        configureUI()
    }
    
    static func cellHeight() -> CGFloat {
            return 250
    }
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingThumbnailCell"
   
    let review = RecommendPlaceReviewThumbnail().then{
        $0.wrap.layer.cornerRadius = 0
        $0.img.image = UIImage(named: "")
    }
    
    lazy var xMarkButton = UIButton().then {
        let iconImage = UIImage(systemName: "xmark")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .white
    }

    
    //MARK: - configure UI
    
    private func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews(){
        contentView.addSubview(review)
        contentView.addSubview(xMarkButton)
    }
    
    private func setConstraints(){
        review.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        xMarkButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
}

