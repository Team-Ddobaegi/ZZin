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
    var selectedKeywordsCount = 0
    
    var label = UILabel().then {
        $0.text = "테스트 제목"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        $0.layer.cornerRadius = 10
    }
    
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
        addSubview(label)
    }
    
    func setSelected(_ selected: Bool, animated: Bool){}
    
    
    // MARK: - ConfigureUI
    
    func setConstraints(){
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
