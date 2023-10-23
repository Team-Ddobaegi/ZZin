//
//  KeywordCollectionViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/20.
//

import UIKit
import SnapKit
import Then

class KeywordCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifer: String = "cell"
    
    let titleButton = UIButton().then {
        $0.setTitle("테스트 제목", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderWidth = 0.7
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        contentView.addSubview(titleButton)
        setUI()
    }
    
    func setUI() {
        titleButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func buttonTapped() {
        print("키워드 셀 클릭")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
