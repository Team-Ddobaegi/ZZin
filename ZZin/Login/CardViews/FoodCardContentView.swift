//
//  FoodCardContentView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/18.
//

import UIKit

class FoodCardContentView: UIView {
    
    // 배경 설정
    private let backgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let gradientLayer = CAGradientLayer().then {
        $0.colors = [UIColor.black.withAlphaComponent(0.01).cgColor,
                     UIColor.black.withAlphaComponent(0.8).cgColor]
        // 아래에서 위로 gradient 컬러를 적용하는 방법
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    // convenience init도 필요한가?
    init(withImage image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        initializer()
    }
    
    private func initializer() {
        // 배경을 cardView에 부착시킨 이후
        addSubview(backgroundView)
        backgroundView.anchorToSuperview()
        // 배경에 이미지를 넣는 방식
        backgroundView.addSubview(imageView)
        imageView.anchorToSuperview()
        
        applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
        // 배경 뷰에 gradient를 넣고 싶은데, imageView.layer위에 넣을 수 있도록 요청하는 것
        backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let heightFactor: CGFloat = 0.35
        gradientLayer.frame = CGRect(x: 0, y: (1 - heightFactor * bounds.height),
                                     width: bounds.width, height: (heightFactor * bounds.height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
