//
//  KeywordCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/24/23.
//

import UIKit

class MatchingKeywordCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer: String = "keywordCell"
    weak var keywordVC: MatchingKeywordVC?
    var keywordType: MatchingKeywordType = .companion

    
    var label = UILabel().then {
        $0.text = "테스트 제목"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
//    override var isSelected: Bool{
//        didSet{
//            if isSelected {
//                contentView.layer.borderColor = ColorGuide.main.cgColor
//            }
//            else{
//                contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
//            }
//        }
//        
//    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Settings
    func setView(){
        contentView.addSubview(label)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        contentView.layer.cornerRadius = 10
//        isSelected()
    }
    
    
    
    // MARK: - ConfigureUI
    
    func setConstraints(){
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
