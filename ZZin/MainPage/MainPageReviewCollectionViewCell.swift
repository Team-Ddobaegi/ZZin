//
//  MainPageReviewCollectionViewCell.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit

class MainPageReviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MainPageReviewCollectionViewCell"
    
    var isBookmarked = false
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    var picture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        return imageView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "맛집명"
        label.textAlignment = .left
        label.font = FontGuide.size14Bold
        label.textColor = .black
        label.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        return label
    }()
    
    let title2: UILabel = {
        let label = UILabel()
        label.text = "여긴 찐짜 맛있네요~ 지금껏 먹..."
        label.textAlignment = .left
        label.font = FontGuide.size14Bold
        label.textColor = .black
        label.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, title2])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()

    
    let bookmark: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookMark"), for: .normal)
        button.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.equalTo(13.82)
            make.height.equalTo(12)
        }
        return button
    }()
    
    @objc func bookmarkTapped() {
        }
}

extension MainPageReviewCollectionViewCell {
    func setupUI() {
        
        view.addSubview(picture)
        picture.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        view.addSubview(titleStackView)
        title.snp.makeConstraints { make in
            make.top.equalTo(picture.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
        }
        
        view.addSubview(bookmark)
        bookmark.snp.makeConstraints { make in
            make.top.equalTo(title.snp.top).offset(5)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
}
