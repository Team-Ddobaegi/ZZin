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
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingPlacePhotoCollectionViewCell"
    
    var placeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "")
        image.backgroundColor = .systemGray6
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        
        return image
    }()
    
    let infoLabel = UILabel().then {
        $0.text = "등록된 이미지가\n없습니다."
        $0.textAlignment = .center
    }
    
    // MARK: - ConfigureUI
    
    func configureUI(){
        addSubview(placeImage)
//        addSubview(infoLabel)
        
        placeImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        infoLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.height.equalToSuperview()
//        }
    }
}
