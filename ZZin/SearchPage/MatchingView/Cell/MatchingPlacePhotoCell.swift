//
//  MatchingRestaurantPhotoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then


//MARK: - 컬렉션뷰가 들어갈 TableView Cell

class MatchingPlacePhotoCell: UITableViewCell {
   
    // MARK: - Properties
    
    static let identifier = "MatchingPlacePhotoCell"
    
    var matchingPlacePhotoView = MatchingPlacePhotoView()
   
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Settings
    
    private func setView() {
        contentView.addSubview(matchingPlacePhotoView)
        matchingPlacePhotoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    
}

