//
//  CustomButton.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/02.
//

import UIKit

class CustomButton: UIButton {

    init(title: String, img: String, width: Int? = nil, height: Int? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setImage(UIImage(named: img), for: .normal)

        self.backgroundColor = ColorGuide.subButton
        self.titleLabel?.font = FontGuide.size16Bold
        self.imageView?.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        self.contentVerticalAlignment = .top
        self.contentHorizontalAlignment = .leading
        self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)

        let defaultWidth = width ?? 105
        let defaultHeight = height ?? 120

        self.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: defaultWidth, height: defaultHeight))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func replaceImage(image: String) {
        self.setImage(UIImage(named: image), for: .normal)
    }
}
