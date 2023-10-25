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
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleButton()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Settings
    
    func setTitleButton(){
        cellButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func toggleSelection() {
        isSelected = !isSelected
        
        if isSelected {
            cellButton.layer.borderColor = ColorGuide.cherryTomato.cgColor
            addSelectedKeyword()
        } else {
            cellButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            removeSelectedKeyword()
        }
        keywordVC?.updateInfoLabel(keywordType)
    }

    func addSelectedKeyword() {
        guard let text = cellButton.titleLabel?.text else {
            return
        }
        switch keywordType {
        case .with:
            keywordVC?.selectedWithKeywords.append(text)
        case .condition:
            keywordVC?.selectedConditionKeywords.append(text)
        case .menu:
            keywordVC?.selectedMenuKeywords.append(text)
        }
    }

    func removeSelectedKeyword() {
        guard let text = cellButton.titleLabel?.text else {
            return
        }
        
        switch keywordType {
        case .with:
            if let index = keywordVC?.selectedWithKeywords.firstIndex(of: text) {
                keywordVC?.selectedWithKeywords.remove(at: index)
            }
        case .condition:
            if let index = keywordVC?.selectedConditionKeywords.firstIndex(of: text) {
                keywordVC?.selectedConditionKeywords.remove(at: index)
            }
        case .menu:
            if let index = keywordVC?.selectedMenuKeywords.firstIndex(of: text) {
                keywordVC?.selectedMenuKeywords.remove(at: index)
            }
        }
    }

    
    //MARK: - Properties
    
    var keywordType: KeywordType = .with
    
    weak var keywordVC: KeywordVC?
    
    static let reuseIdentifer: String = "cell"
    
    let cellButton = UIButton().then {
        $0.setTitle("테스트 제목", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    var isButtonSelected = false
    
    
    
    // MARK: - ConfigureUI
    
    func configureUI() {
        contentView.addSubview(cellButton)
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Actions
    
    @objc func buttonTapped() {
        print("\(cellButton.currentTitle ?? "") 선택됨")
        
        toggleSelection()
    }
}
