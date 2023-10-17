//
//  MainView.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    private let recommendedLabel: UILabel = {
        let label = UILabel()
        label.text = "로컬들이 추천해 주는 내 주변"
        label.font = FontGuide.size19
        label.textColor = .black
        return label
    }()
    
    private let zzinLabel: UILabel = {
        let label = UILabel()
        label.text = " 찐 "
        label.font = FontGuide.size19Bold
        label.textColor = .black
        return label
    }()
    
    private let recommendedLabel2: UILabel = {
        let label = UILabel()
        label.text = "맛집!"
        label.font = FontGuide.size19
        label.textColor = .black
        return label
    }()
    
    private lazy var recommendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendedLabel, zzinLabel, recommendedLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    let recommendcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MainPageRecommendCollectionViewCell.self, forCellWithReuseIdentifier: MainPageRecommendCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let rangkingLabel: UILabel = {
        let label = UILabel()
        label.text = "이번주 성동구"
        label.font = FontGuide.size19
        label.textColor = .black
        return label
    }()
    
    private let rangkingLabel2: UILabel = {
        let label = UILabel()
        label.text = "맛집 랭킹"
        label.font = FontGuide.size19
        label.textColor = .black
        return label
    }()

    private lazy var rangkingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rangkingLabel, zzinLabel, rangkingLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MainPageRankingCollectionViewCell.self, forCellWithReuseIdentifier: MainPageRankingCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "로컬들의 실시간 맛집"
        label.font = FontGuide.size19
        label.textColor = .black
        return label
    }()

    private let reviewLabel2: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.font = FontGuide.size19
        label.textColor = .black
        return label
    }()

    private lazy var reviewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [reviewLabel, zzinLabel,  reviewLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    let reviewcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MainPageReviewCollectionViewCell.self, forCellWithReuseIdentifier: MainPageReviewCollectionViewCell.identifier)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(recommendStackView)
        recommendStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalTo(20)
//            make.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        addSubview(recommendcollectionView)
        recommendcollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendStackView.snp.bottom).offset(15)
            make.trailing.leading.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        addSubview(rangkingStackView)
        rangkingStackView.snp.makeConstraints { make in
            make.top.equalTo(recommendcollectionView.snp.bottom).offset(15)
            make.leading.equalTo(20)
            make.height.equalTo(40)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(rangkingStackView.snp.bottom).offset(15)
            make.leading.equalTo(245)
        }
        
        addSubview(reviewStackView)
        reviewStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.leading.equalTo(20)
//            make.trailing.equalTo(-32)
        }
        
        addSubview(reviewcollectionView)
        reviewcollectionView.snp.makeConstraints { make in
            make.top.equalTo(reviewStackView.snp.bottom).offset(15)
            make.leading.equalTo(20)
            make.height.equalTo(151)
        }
    }

    
    
    
    }
