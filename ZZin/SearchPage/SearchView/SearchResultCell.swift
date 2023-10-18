//
//  SearchResultCollectionViewCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/17/23.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    static let identifier = "searchResultCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    func setImageView(){
        backgroundColor = .systemBlue
        
        addSubview(imageView)
        
    
    }
    
}
