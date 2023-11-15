//
//  ButtonCollectionViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/15.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    static let identifier = "ButtonCollectionViewCell"
    
    var image = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    var numberLabel = UILabel().then {
        $0.text = "1위"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.baselineAdjustment = .alignBaselines
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init 오류")
    }
    
    func configureUI(){
        addSubViews()
    }
    
    func addSubViews() {
        contentView.addSubview(image)
        image.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(19)
        }
        
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(10)
//            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
}
