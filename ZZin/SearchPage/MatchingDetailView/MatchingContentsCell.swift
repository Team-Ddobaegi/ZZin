//
//  MatchingContentsCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit


//MARK: - 매칭 업체 리뷰 내용 :: TableView Cell

class MatchingContentsCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingContentsCell"
    
    private let background = UIView().then {
        // 컴포넌트들을 그려넣을 백그라운드
        $0.backgroundColor = .white
    }
    
    
    //MARK: - Settings
    
    private func setView() {
        contentView.addSubview(background)
        
        configureUI()
    }
    private func configureUI(){
        background.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
