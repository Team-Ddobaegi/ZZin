//
//  MatcingView.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

class MatcingView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Properties
    
    private let searchResultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.text = "3가지를 가진 맛집"
        $0.textColor = .black
    }
    
    //MARK: - Configure
    
    private func configureUI(){
        
    }
    
}
