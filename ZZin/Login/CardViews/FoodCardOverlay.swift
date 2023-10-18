//
//  FoodCardOverlay.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/18.
//

import UIKit
import Shuffle

class FoodCardOverlay: UIView {
    
    // initializing Transparent UIView for swipe
    init(direction: SwipeDirection) {
        // super init을 할 때 frame은 왜 zero가 돼야할까?
        super.init(frame: .zero)
        
        switch direction {
        case .left:
            createLeftOverlay()
        case .right:
            createRightOverlay()
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func createLeftOverlay() {
        // 왼쪽으로 스와이프되는 view에 Label 생성
        let leftTextView = OverlayLabelView(withTitle: "싫어요!", color: .red, rotation: CGFloat.pi/10)
        addSubview(leftTextView)
        leftTextView.anchor(top: topAnchor,
                            right: rightAnchor,
                            paddingTop: 30,
                            paddingRight: 14)
    }

    private func createRightOverlay() {
        // 오른쪽으로 스와이프되는 view에 Label 생성
        let rightTextView = OverlayLabelView(withTitle: "좋아요!", color: .blue, rotation: -CGFloat.pi/10)
        addSubview(rightTextView)
        rightTextView.anchor(top: topAnchor,
                            left: leftAnchor,
                            paddingTop: 26,
                            paddingRight: 14)
    }
}

// 이건 overlay Label 그 자체
private class OverlayLabelView: UIView {
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    init(withTitle title: String, color: UIColor, rotation: CGFloat) {
        super.init(frame: CGRect.zero)
        layer.borderColor = color.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 4
        // swipe 정도에 따라 컬러 값 변동
        transform = CGAffineTransform(rotationAngle: rotation)
        
        addSubview(titleLabel)
        titleLabel.textColor = color
        
        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 8, paddingRight: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        return nil
    }
}
