//
//  MatchingReViewDetailView.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit
import Then


//MARK: - 매칭 업체 로컬주민 리뷰 :: TableView 세팅

class MatchingDetailView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Properties
    
    // 매칭 업체 리뷰가 보여지는 테이블뷰입니두
    lazy var setMatchingDetailTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
    }
    
    
    //MARK: - Settings
    
    private func setView() {
       addSubview(setMatchingDetailTableView)
        
        configureUI()
    }
    
    
    //MARK: - Configure
    
    private func configureUI(){
        tableViewConstraints()
    }
    
    private func tableViewConstraints() {
        setMatchingDetailTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-90)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
