//
//  MatchingReViewDetailView.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit
import Then

class MatchingDetailView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Properties
    
    lazy var xMarkButton = UIButton().then {
        let iconImage = UIImage(systemName: "xmark")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = ColorGuide.main
    }
    
    
    private func setAddSubView() {
        addSubview(xMarkButton)
    }
    
    
    //MARK: - Configure
    
    private func configureUI(){
        setButtonConstraints()
    }
    
    private func setButtonConstraints() {
        // 엑스 버튼
        xMarkButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
