//
//  SearchResultCollectionViewCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/17/23.
//

import UIKit
import SnapKit
import Then

// MARK: - SearchView 하단에 나올 "검색결과" 컬렉션뷰 :: 키워드 입력 완료 시 나오는 뷰

class SearchResultCell: UICollectionViewCell {
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    // MARK: - Properties
    
    static let identifier = "searchResultCell"
    
    private let review = RecommendPlaceThumbnail().then{
        $0.wrap.layer.cornerRadius = 15
    }
   
    
    //MARK: - ConfigureUI
    
    private func configureUI(){
        addSubview(review)
        
        review.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
