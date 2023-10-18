//
//  FoodCardFooterView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/18.
//

import UIKit

class FoodCardFooterView: UIView {
    
    private let label = UILabel()
    private var gradientLayer: CAGradientLayer?
    
    init(withTitle title: String?) {
        super.init(frame: .zero)
        backgroundColor = .clear
        // Footer 영역인 좌우측하단에 masked Corner 적용
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        clipsToBounds = true
        isOpaque = false
        initialize(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(title: String?) {
        // init을 한 이후에 변화를 줄 수 있는 NSMutableAttributedString
        
        let attributedString = NSMutableAttributedString(string: (title ?? "") + "\n",
                                                       attributes: NSAttributedString.Key.titleAttributes)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                       range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        addSubview(label)
    }
    
    // card가 구성된 이후 label이 배치될 수 있도록 지정(onto the card)
    override func layoutSubviews() {
        let padding: CGFloat = 20
        label.frame = CGRect(x: padding, y: bounds.height - label.intrinsicContentSize.height - padding,
                             width: bounds.width, height: label.intrinsicContentSize.height)
    }
}
