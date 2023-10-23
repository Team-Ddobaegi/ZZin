//
//  MainView.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    let zzinlogoPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ZZin")
        imageView.backgroundColor = ColorGuide.subButton
//        imageView.layer.cornerRadius = 38
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(75)
        }
        return imageView
    }()

        
    private let recommendedLabel: UILabel = {
        let label = UILabel()
        label.text = "로컬들이 추천해 주는 내 주변"
        label.font = FontGuide.size16Bold
        label.textColor = .black
        return label
    }()
    
    private let firstzzinLabel: UILabel = {
        let label = UILabel()
        label.text = " 찐 "
        label.font = FontGuide.size24Bold
        label.textColor = ColorGuide.main
        return label
    }()
    
    private let recommendedLabel2: UILabel = {
        let label = UILabel()
        label.text = "맛집!"
        label.font = FontGuide.size16Bold
        label.textColor = .black
        return label
    }()
    
    private lazy var recommendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendedLabel, firstzzinLabel, recommendedLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .center
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
        label.font = FontGuide.size16Bold
        label.textColor = .black
        return label
    }()
    
    private let secondzzinLabel: UILabel = {
        let label = UILabel()
        label.text = " 찐 "
        label.font = FontGuide.size24Bold
        label.textColor = ColorGuide.main
        return label
    }()

    private let rangkingLabel2: UILabel = {
        let label = UILabel()
        label.text = "맛집 랭킹"
        label.font = FontGuide.size16Bold
        label.textColor = .black
        return label
    }()

    private lazy var rangkingLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rangkingLabel, secondzzinLabel, rangkingLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    let rank1Button: UIButton = {
        let button = UIButton()
        button.setTitle("1위", for: .normal)
        button.titleLabel?.font = FontGuide.size16Bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 25
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)

        button.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(120)
        }
        return button
    }()
        
    let rank2Button: UIButton = {
        let button = UIButton()
        button.setTitle("2위", for: .normal)
        button.titleLabel?.font = FontGuide.size16Bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 25
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)

        button.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(120)
        }
        return button
    }()

    let rank3Button: UIButton = {
        let button = UIButton()
        button.setTitle("3위", for: .normal)
        button.titleLabel?.font = FontGuide.size16Bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 25
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)


        button.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(120)
        }
        return button
    }()

    private lazy var firstRankButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rank1Button, rank2Button, rank3Button])
        stackView.axis = .horizontal
        stackView.spacing = 19
        return stackView
    }()

    let rank4Button: UIButton = {
        let button = UIButton()
        button.setTitle("4위", for: .normal)
        button.titleLabel?.font = FontGuide.size16Bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 25
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)

        button.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(120)
        }
        return button
    }()

    let rank5Button: UIButton = {
        let button = UIButton()
        button.setTitle("5위", for: .normal)
        button.titleLabel?.font = FontGuide.size16Bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 25
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)

        button.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(120)
        }
        return button
    }()

    let rank6Button: UIButton = {
        let button = UIButton()
        button.setTitle("6위", for: .normal)
        button.titleLabel?.font = FontGuide.size16Bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 25
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)

        button.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(120)
        }
        return button
    }()
    
    private lazy var secondRankButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rank4Button, rank5Button, rank6Button])
        stackView.axis = .horizontal
        stackView.spacing = 19
        return stackView
    }()
    
    private lazy var rankButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstRankButtonStackView, secondRankButtonStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "로컬들의 실시간 맛집"
        label.font = FontGuide.size16Bold
        label.textColor = .black
        return label
    }()

    private let thirdzzinLabel: UILabel = {
        let label = UILabel()
        label.text = " 찐 "
        label.font = FontGuide.size24Bold
        label.textColor = ColorGuide.main
        return label
    }()

    private let reviewLabel2: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.font = FontGuide.size16Bold
        label.textColor = .black
        return label
    }()

    private lazy var reviewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [reviewLabel, thirdzzinLabel,  reviewLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    let reviewCollectionView: UICollectionView = {
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
        
        addSubview(zzinlogoPicture)
        zzinlogoPicture.snp.makeConstraints {
            $0.top.equalToSuperview().offset(39)
            $0.leading.equalTo(15)
//            make.trailing.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(100)

        }

        addSubview(recommendStackView)
        recommendStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(9)
            $0.leading.equalTo(20)
//            make.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }

        addSubview(recommendcollectionView)
        recommendcollectionView.snp.makeConstraints {
            $0.top.equalTo(recommendStackView.snp.bottom).offset(15)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        addSubview(rangkingLabelStackView)
        rangkingLabelStackView.snp.makeConstraints {
            $0.top.equalTo(recommendcollectionView.snp.bottom).offset(0)
            $0.leading.equalTo(20)
            $0.height.equalTo(40)
        }
        
        addSubview(rankButtonStackView)
        rankButtonStackView.snp.makeConstraints {
            $0.top.equalTo(rangkingLabelStackView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
        }
                
        addSubview(reviewStackView)
        reviewStackView.snp.makeConstraints {
            $0.top.equalTo(rankButtonStackView.snp.bottom).offset(15)
            $0.leading.equalTo(20)
        }
        addSubview(reviewCollectionView)
        reviewCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-3)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(353)
            $0.height.equalTo(145)
        }
    }
    }
