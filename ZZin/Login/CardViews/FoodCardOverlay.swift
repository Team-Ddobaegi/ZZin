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
        // 왼쪽으로 스와이프되는 view 생성
        let leftTextView = OverlayLabelView(withTitle: "싫어요!", color: .red, rotation: CGFloat.pi/10)
        addSubview(leftTextView)
    }

    private func createRightOverlay() {
        
    }
}

private class OverlayLabelView: UIView {
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    init(withTitle title: String, color: UIColor, rotation: CGFloat) {
        super.init(frame: CGRect.zero)
        layer.borderColor = color.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 4
        transform = CGAffineTransform(rotationAngle: rotation)
        
        addSubview(titleLabel)
        titleLabel.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        return nil
    }
}
