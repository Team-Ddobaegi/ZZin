//
//  SearchCustomItem.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/16/23.
//

import Foundation
import UIKit

class KeywordButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        setTitleColor(.systemGray2, for: .normal)
        setTitleColor(.systemRed, for: .highlighted)
        backgroundColor = UIColor.white
        layer.cornerRadius = 35 / 2
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        self.snp.makeConstraints {
            $0.width.equalTo(108)
            $0.height.equalTo(38)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
