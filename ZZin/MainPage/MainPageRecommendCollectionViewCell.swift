//
//  MainPageRecommendCollectionViewController.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit

class MainPageRecommendCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MainPageRecommendCollectionViewCell"
    private var isBookmarked = false
    
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 38
        view.clipsToBounds = true
        return view
    }()


    let recommendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 38
        return button
    }()
    
    private let recommendLabel: UILabel = {
        let label = UILabel()
        label.text = "도시명"
        label.font = FontGuide.size16
        label.textColor = .black
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        return label
    }()

    private lazy var recommendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendButton, recommendLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()

//    override func prepareForReuse() {
//        super .prepareForReuse()
//    }
}

extension MainPageRecommendCollectionViewCell {
    func setupUI() {
        
        view.addSubview(recommendButton)
        recommendButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalTo(76)
            }

        view.addSubview(recommendLabel)
        recommendLabel.snp.makeConstraints {
            $0.top.equalTo(recommendButton.snp.bottom).offset(8)
            $0.width.equalTo(37)
            $0.height.equalTo(17)
            }

        }
}
