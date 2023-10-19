//
//  KeywordCollectionViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/20.
//

import UIKit
import SnapKit

class KeywordCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifer: String = "cell"
    
    var titleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("테스트 제목", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 15.23
        btn.clipsToBounds = true
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        contentView.addSubview(titleButton)
        setUI()
    }
    
    func setUI() {
        titleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func buttonTapped() {
        print("버튼이 눌렸습니다.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
