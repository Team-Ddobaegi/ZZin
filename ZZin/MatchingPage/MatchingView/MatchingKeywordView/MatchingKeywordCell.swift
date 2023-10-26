//
//  KeywordCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/24/23.
//

import UIKit

class MatchingKeywordCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var keywordType: KeywordType = .with
    
    weak var keywordVC: MatchingKeywordVC?
    
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
    
    // 셀 선택했을 때 실행되는 메서드입니두
    func isSelected(){
        if isSelectedCell {
            // 셀 선택시 테두리 컬러 변경
            contentView.layer.borderColor = selectedBorderColor.cgColor
            // 셀 선택시 선택된 셀의 입력값 저장 메서드
            addSelectedKeyword()
        } else {
            // 셀 선택 해제시 원래 테두리 색으로 돌아감
            contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            // 셀 선택 해제시 실행되는 저장된 셀 삭제 메서드
            removeSelectedKeyword()
        }
        // 저장된 키워드를 각 키워드 배열에 저장
        keywordVC?.updateInfoLabel(keywordType)
    }
    
    // 셀 선택시 선택된 셀의 입력값 저장 메서드
    func addSelectedKeyword() {
        guard let text = label.text else { return }
        
        switch keywordType {
        case .with:
            keywordVC?.selectedWithKeywords.append(text)
        case .condition:
            keywordVC?.selectedConditionKeywords.append(text)
        case .menu:
            keywordVC?.selectedMenuKeywords.append(text)
        }
    }

    // 셀 선택 해제시 실행되는 저장된 셀 삭제 메서드
    func removeSelectedKeyword() {
        guard let text = label.text else { return }
        
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
    
    
    // MARK: - ConfigureUI
    
    func setConstraints(){
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
