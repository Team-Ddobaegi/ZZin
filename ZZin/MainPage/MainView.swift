//
//  MainView.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.register(LocalTableViewCell.self, forCellReuseIdentifier: LocalTableViewCell.identifier)
        $0.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        $0.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.backgroundColor = .white
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("오류가 발생했습니다.")
    }
    
    func setTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//    private let logoPicture = UIImageView().then {
//        $0.image = UIImage(named: "ZZin")
//        $0.backgroundColor = ColorGuide.subButton
//        $0.clipsToBounds = true
//        $0.contentMode = .scaleAspectFill
//        $0.isUserInteractionEnabled = true
//    }
//
//    private let recommendedLabel = UILabel().then {
//        let text = "로컬들이 추천해 주는 내 주변 찐 맛집!"
//        let biggerFont = FontGuide.size24Bold
//
//        let attributedStr = NSMutableAttributedString(string: text)
//        attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
//
//        attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
//        $0.attributedText = attributedStr
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    private let rankingLabel = UILabel().then {
//        let text = "이번주 성동구 찐 맛집 랭킹!"
//        let biggerFont = FontGuide.size24Bold
//
//        let attributedStr = NSMutableAttributedString(string: text)
//        attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
//        attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
//
//        $0.attributedText = attributedStr
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    private var reviewLabel = UILabel().then {
//        let text = "로컬들의 실시간 맛집 찐 리뷰"
//        let biggerFont = FontGuide.size24Bold
//
//        let attributedStr = NSMutableAttributedString(string: text)
//        attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
//
//        attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
//        $0.attributedText = attributedStr
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
