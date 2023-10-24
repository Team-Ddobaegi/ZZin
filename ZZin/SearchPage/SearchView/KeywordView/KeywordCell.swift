//
//  KeywordCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/24/23.
//

import UIKit

class KeywordCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var keywordType: KeywordType = .with
    
    weak var keywordVC: KeywordVC?
    
    static let reuseIdentifer: String = "keywordCell"
    
    let selectedBorderColor: UIColor = ColorGuide.cherryTomato
    
    var label = UILabel().then {
        $0.text = "테스트 제목"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    var isSelectedCell: Bool = false
    
    
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
        isSelected()
    }
    
    func isSelected(){
        if isSelectedCell {
            contentView.layer.borderColor = selectedBorderColor.cgColor
            addSelectedKeyword()
        } else {
            contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            removeSelectedKeyword()
        }
        keywordVC?.updateInfoLabel(keywordType)
    }
    
    func addSelectedKeyword() {
        guard let text = label.text else { return }
        
        switch keywordType {
        case .with:
            keywordVC?.selectedFirstKeywords.append(text)
        case .condition:
            keywordVC?.selectedSecondKeywords.append(text)
        case .menu:
            keywordVC?.selectedMenuKeywords.append(text)
        }
    }

    func removeSelectedKeyword() {
        guard let text = label.text else { return }
        
        switch keywordType {
        case .with:
            if let index = keywordVC?.selectedFirstKeywords.firstIndex(of: text) {
                keywordVC?.selectedFirstKeywords.remove(at: index)
            }
        case .condition:
            if let index = keywordVC?.selectedSecondKeywords.firstIndex(of: text) {
                keywordVC?.selectedSecondKeywords.remove(at: index)
            }
        case .menu:
            if let index = keywordVC?.selectedMenuKeywords.firstIndex(of: text) {
                keywordVC?.selectedMenuKeywords.remove(at: index)
            }
        }
    }
    
    
    // MARK: - ConfigureUI
    
    func setConstraints(){
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
