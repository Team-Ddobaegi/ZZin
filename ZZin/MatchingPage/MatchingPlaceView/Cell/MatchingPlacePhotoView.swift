//
//  MatchingRestaurantPhotoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then


//MARK: - 매칭 업체 사진들을 넣는 "컬렉션뷰"가 들어갈 UIView

class MatchingPlacePhotoView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Properties
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MatchingPlacePhotoCollectionViewCell.self, forCellWithReuseIdentifier: MatchingPlacePhotoCollectionViewCell.identifier)
        
        return cv
    }()
    
    
    //MARK: - ConfigureUI
    
    private func configureUI(){
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    
}

