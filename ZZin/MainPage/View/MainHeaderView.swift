//
//  MainHeaderView.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/03.
//

import UIKit
import SnapKit
import Then

class MainHeaderView: UITableViewHeaderFooterView {
    static let identifier = "MainHeaderView"
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 해당 라벨 값을 바꿔 줘야 한다. -> 다른 함수
    private func setLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    // switch section구분
    func configure(with section: Int) {
        switch section {
        case 0:
            let text = "로컬들이 추천해 주는 내 주변 찐 맛집!"
            let biggerFont = FontGuide.size24Bold
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
            attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
            titleLabel.attributedText = attributedStr
        case 1:
            let text = "이번주 성동구 찐 맛집 랭킹!"
            let biggerFont = FontGuide.size24Bold
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
            attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
            titleLabel.attributedText = attributedStr
        case 2:
            let text = "로컬들의 실시간 맛집 찐 리뷰"
            let biggerFont = FontGuide.size24Bold
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
            attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
            titleLabel.attributedText = attributedStr
        default:
            titleLabel.text = "우리들의 찐 맛집"
        }
    }
}
