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
//        view.layer.cornerRadius = 38
        view.clipsToBounds = true
        return view
    }()

    let recommendPicture: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "")
        imageView.backgroundColor = ColorGuide.subButton
        imageView.layer.cornerRadius = 38
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(76)
        }
        return imageView
    }()

//    let recommendButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .systemGray6
//        button.layer.cornerRadius = 38
//        button.snp.makeConstraints {
//            $0.height.width.equalTo(76)
//        }
//        return button
//    }()
    
    var recommendLabel: UILabel = {
        let label = UILabel()
        label.text = "강남구"
        label.font = FontGuide.size16
        label.textColor = .black
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(50)
        }
        return label
    }()

    private lazy var recommendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendPicture, recommendLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super .prepareForReuse()
    }
}

extension MainPageRecommendCollectionViewCell {
    func setupUI() {
        
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(recommendStackView)
        recommendStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
//            $0.edges.equalToSuperview()
            }


        }
}
