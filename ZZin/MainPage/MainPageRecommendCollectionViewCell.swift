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
    
    private let containerView = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    
    let recommendPictureView = UIImageView().then {
        $0.backgroundColor = ColorGuide.subButton
        $0.layer.cornerRadius = 38
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.snp.makeConstraints {
            $0.height.width.equalTo(76)
        }
    }
    
    var recommendLabel = UILabel().then {
        $0.text = "강남구"
        $0.font = FontGuide.size16
        $0.textColor = .black
        $0.textAlignment = .center
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
        }
    }
    
    private lazy var recommendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendPictureView, recommendLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [containerView, recommendStackView].forEach { self.addSubview($0) }
    }
    
    func setupUI() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        recommendStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
    }
}
