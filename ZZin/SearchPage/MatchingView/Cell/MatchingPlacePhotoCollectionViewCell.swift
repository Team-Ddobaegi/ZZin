//
//  MatchingPlacePhotoCollectionViewCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit


//MARK: - 테이블뷰 셀에 들어갈 CollectionView Cell 세팅 페이지

class MatchingPlacePhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MatchingPlacePhotoCollectionViewCell"
    
    let placePhotoView = UIImageView().then{
        $0.backgroundColor = .lightGray
    }

    
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(){
        addSubview(placePhotoView)
    }
    
    func configureUI(){
        placePhotoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
