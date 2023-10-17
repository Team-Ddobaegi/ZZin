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
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()


    let recommendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 38
        button.snp.makeConstraints { make in
            make.width.height.equalTo(76)
        }
        return button
    }()
    
    private let recommendLabel: UILabel = {
        let label = UILabel()
        label.text = "도시명"
        label.font = FontGuide.size16
        label.textColor = .black
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(19)
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

    override func prepareForReuse() {
        super .prepareForReuse()
    }
}

extension MainPageRecommendCollectionViewCell {
    func setupUI() {
        recommendStackView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
            }
}
