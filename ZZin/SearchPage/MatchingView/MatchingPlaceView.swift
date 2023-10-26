//
//  MatcingView.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then


//MARK: - 매칭 업체 뷰 :: TableView 세팅

class MatchingPlaceView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Properties
    
    lazy var xMarkButton = UIButton().then {
        $0.isEnabled = true
        let iconImage = UIImage(systemName: "xmark")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = ColorGuide.main
    }
    
    // 매칭 업체가 보여지는 테이블뷰입니두
    lazy var setMatchingTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
    }
    
    
    //MARK: - Configure
    
    private func configureUI(){
        addsubViews()
        setConstraints()
    }
    
    private func addsubViews(){
        addSubview(xMarkButton)
        addSubview(setMatchingTableView)
    }
    
    private func setConstraints() {
        // 매칭 업체 로드 테이블뷰
        setMatchingTableView.snp.makeConstraints {
            $0.top.equalTo(xMarkButton.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-90)
            $0.leading.trailing.equalToSuperview()
        }
        
        // 엑스 버튼
        xMarkButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
