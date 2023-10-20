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
        
        setAddsubView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    static let identifier = "MatchingPlaceReviewCell"
    
    let dummyReview1 = ZZinView()
    let dummyReview2 = ZZinView()
    let dummyReview3 = ZZinView()
    
    
    //MARK: - Settings
    
    private func setAddsubView() {
        contentView.addSubview(dummyReview1)
        contentView.addSubview(dummyReview2)
        contentView.addSubview(dummyReview3)
    }
    
    //MARK: - ConfigureUI
    
    private func configureUI(){
        dummyReview1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(180)
        }
        
        dummyReview2.snp.makeConstraints{
            $0.top.equalTo(dummyReview1.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(180)
        }
        
        dummyReview3.snp.makeConstraints{
            $0.top.equalTo(dummyReview2.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(180)
        }
    }
}
