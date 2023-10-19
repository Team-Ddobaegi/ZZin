//
//  MatchingRestaurantPhotoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

class MatchingPlacePhotoCell: UICollectionViewCell {
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddsubView()
        setCellAttribute()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    static let identifier = "MatchingRestaurantPhotoCell"
    
    public let view = UIView().then {
        $0.backgroundColor = .black
    }
    
    
    //MARK: - Settings
    
    
    private func setAddsubView() {
        addSubview(view)
    }
    
    private func setCellAttribute(){
        // 셀 세팅
        layer.cornerRadius = 25
        backgroundColor = .systemGray6
    }
    
    //MARK: - ConfigureUI
    private func setConstraints(){
        // 업체 정보를 보여줄 뷰
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
    }
}

