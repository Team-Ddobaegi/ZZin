//
//  MainView.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

class MainView: UIView {
    private let logoPicture = UIImageView().then {
        $0.image = UIImage(named: "ZZin")
        $0.backgroundColor = ColorGuide.subButton
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }

    private let recommendedLabel = UILabel().then {
        let text = "로컬들이 추천해 주는 내 주변 찐 맛집!"
        let biggerFont = FontGuide.size24Bold
        
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
        
        attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
        $0.attributedText = attributedStr
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let rankingLabel = UILabel().then {
        let text = "이번주 성동구 찐 맛집 랭킹!"
        let biggerFont = FontGuide.size24Bold
        
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
        attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
        
        $0.attributedText = attributedStr
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let horizontalFlow = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }

    lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalFlow).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MainPageRecommendCollectionViewCell.self, forCellWithReuseIdentifier: MainPageRecommendCollectionViewCell.identifier)
    }
    
    lazy var reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalFlow).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MainPageReviewCollectionViewCell.self, forCellWithReuseIdentifier: MainPageReviewCollectionViewCell.identifier)
    }
    
    let topRankButton = CustomButton(title: "1위", img: "대갈")
    let secondRankButton = CustomButton(title: "2위", img: "마리오")
    let thirdRankButton = CustomButton(title: "3위", img: "바위파스타")
    let fourthRankButton = CustomButton(title: "4위", img: "소감")
    let fifthRankButton = CustomButton(title: "5위", img: "송계옥")
    let sixthRankButton = CustomButton(title: "6위", img: "멘쇼")
    
    private lazy var topRankStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topRankButton, secondRankButton, thirdRankButton])
        stackView.axis = .horizontal
        stackView.spacing = 19
        return stackView
    }()
    
    private lazy var follwupRankStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fourthRankButton, fifthRankButton, sixthRankButton])
        stackView.axis = .horizontal
        stackView.spacing = 19
        return stackView
    }()
    
    private lazy var rankButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topRankStackView, follwupRankStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private var reviewLabel = UILabel().then {
        let text = "로컬들의 실시간 맛집 찐 리뷰"
        let biggerFont = FontGuide.size24Bold
        
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
        
        attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
        $0.attributedText = attributedStr
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = UIColor.white
        [logoPicture, recommendedLabel, recommendCollectionView, rankingLabel, rankButtonStackView, reviewLabel, reviewCollectionView].forEach { addSubview($0) }
    }
    
    func setupUI() {
        logoPicture.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-60)
            $0.leading.equalTo(15)
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        recommendedLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(9)
            $0.leading.equalTo(20)
            $0.height.equalTo(30)
        }
        
        recommendCollectionView.snp.makeConstraints {
            $0.top.equalTo(recommendedLabel.snp.bottom).offset(15)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.top.equalTo(recommendCollectionView.snp.bottom).offset(0)
            $0.leading.equalTo(20)
            $0.height.equalTo(40)
        }
        
        rankButtonStackView.snp.makeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(rankButtonStackView.snp.bottom).offset(10)
            $0.leading.equalTo(20)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(237)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
