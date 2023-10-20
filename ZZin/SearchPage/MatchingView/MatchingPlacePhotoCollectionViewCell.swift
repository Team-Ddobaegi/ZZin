//
//  MatchingPlacePhotoCollectionViewCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit

class MatchingPlacePhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MatchingPlacePhotoCollectionViewCell"
    
    let imageView = UIImageView().then{
        $0.backgroundColor = .blue
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
        addSubview(imageView)
    }
    
    func configureUI(){
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
