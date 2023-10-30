//
//  OpacityView.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/24/23.
//

import UIKit
import SnapKit
import Then

class OpacityView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Properties
    
    let view = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.7
    }
    
    //MARK: - ConfigureUI
    
    func configureUI(){
        addSubview(view)
        
        view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}
