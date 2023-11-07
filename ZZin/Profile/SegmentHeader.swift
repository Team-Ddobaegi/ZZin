//
//  SegmentHeader.swift
//  ZZin
//
//  Created by 남보경 on 2023/10/29.
//

import UIKit
import SnapKit

class SegmentHeader: UICollectionReusableView {
    static let identifier = "SegmentHeader"
    
    var customSegmentedControl: CustomSegmentedControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegmentedControl() {
        let segmentedControlTitles = ["맛집 추천", "리뷰"]
        customSegmentedControl = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.bounds.width - 32, height: 50), buttonTitles: segmentedControlTitles)
        
        addSubview(customSegmentedControl)
        
        customSegmentedControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
