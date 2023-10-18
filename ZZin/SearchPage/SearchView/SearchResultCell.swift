//
//  SearchResultCollectionViewCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/17/23.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddsubView()
        setCellAttribute()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    static let identifier = "searchResultCell"
    
    
    private let thumbnailImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    private let recommendTitle = UILabel().then {
        $0.text = "추천맛집"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textAlignment = .left
    }
    private let recommendContents = UILabel().then {
        $0.text = "냠냠쩝쩝 나는야 쩝쩝박사"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textAlignment = .left
    }
    
    //MARK: - Settings
    
    
    private func setAddsubView() {
        addSubview(thumbnailImage)
        addSubview(recommendTitle)
        addSubview(recommendContents)
    }
    
    private func setCellAttribute(){
        // 셀 세팅
        layer.cornerRadius = 25
        backgroundColor = .systemGray6
    }
    
    //MARK: - ConfigureUI
    
    private func configureUI(){
        recommendTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(155)
            $0.leading.equalToSuperview().offset(15)
        }
        
        recommendContents.snp.makeConstraints {
            $0.bottom.equalTo(recommendTitle).offset(22)
            $0.leading.equalToSuperview().offset(15)
        }
    }
}
