//
//  MainPageRecommendCollectionViewController.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

class LocalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LocalCollectionViewCell"
    private var isBookmarked = false
    
    private var recommendPictureView = UIImageView().then {
        let image = UIImage(systemName: "person")
        $0.image = image
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 70 / 2
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
        $0.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(72)

        }
    }
    
    private var recommendLabel = UILabel().then {
        $0.text = "강남구"
        $0.font = FontGuide.size16
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var recommendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendPictureView, recommendLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubview()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubview() {
        contentView.addSubview(recommendStackView)
        recommendStackView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
            $0.size.equalTo(CGSize(width: 70, height: 100))
        }
    }
    
    func setComponents(text: String, image: String) {
        let imageData = UIImage(systemName: image)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        recommendPictureView.image = imageData
        recommendLabel.text = text
    }
}
