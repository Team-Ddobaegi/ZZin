//
//  MainPageReviewCollectionViewCell.swift
//  ZZin
//
//  Created by clone1 on 2023/10/15.
//

import UIKit
import SnapKit

class MainPageReviewCollectionViewCell: UICollectionViewCell {
        static let identifier = "MainPageReviewCollectionViewCell"

    
    
//    class ViewForReview: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUI()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        let wrap = UIView().then {
//            $0.layer.cornerRadius = 50
            $0.clipsToBounds = true

            $0.backgroundColor = .black
        }
    
    let img = UIImageView().then{
//        imageView.image = UIImage(named: "")
        $0.backgroundColor = ColorGuide.subButton
        $0.layer.opacity = 0.4
        $0.clipsToBounds = true
    }

        
        let titleLabel = UILabel().then {
            $0.text = "삼겹살의 근본,\n구워주는 고기집 \"하남돼지집\""
            $0.font = FontGuide.size19Bold
            $0.textColor = .white
            $0.numberOfLines = 2 // 2줄로 제한
            $0.textAlignment = .left
            $0.baselineAdjustment = .alignBaselines
        }
        
        let regionLabel = UILabel().then {
            $0.text = "강남구" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
            $0.font = FontGuide.size14Bold
            $0.textColor = .white
            $0.numberOfLines = 1 // 1줄로 제한
            $0.textAlignment = .left
            $0.baselineAdjustment = .alignBaselines
        }
        
        let companyLabel = UILabel().then {
            $0.text = "#회식 장소로 제격🍺" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
            $0.font = FontGuide.size14
            $0.textColor = .white
        }
        
        let conditionLabel = UILabel().then {
            $0.text = "#직접 손질해주는🥓" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
            $0.font = FontGuide.size14
            $0.textColor = .white
        }
    
        
        let underline = UIView().then {
            $0.backgroundColor = UIColor(red: 226, green: 58, blue: 37, alpha: 1.0)
        }
        
        func setAutoLayout() {
            wrap.snp.makeConstraints{
                $0.edges.centerX.centerY.equalToSuperview()
                $0.size.equalTo(CGSize(width: 353, height: 237))
            }
            
            wrap.addSubview(img)
            img.snp.makeConstraints{
                $0.edges.equalToSuperview()
            }
            
            wrap.addSubview(titleLabel)
            titleLabel.snp.makeConstraints{
                $0.bottom.equalToSuperview().inset(6)
                $0.left.equalToSuperview().offset(20)

                $0.size.equalTo(CGSize(width: 300, height: 60))
            }
            
            wrap.addSubview(companyLabel)
            companyLabel.snp.makeConstraints{
                $0.top.equalTo(wrap.snp.top).offset(10)
                $0.left.equalTo(wrap.snp.left).offset(20)
            }
            
            wrap.addSubview(conditionLabel)
            conditionLabel.snp.makeConstraints{
                $0.top.equalToSuperview().inset(10)
                $0.left.equalTo(companyLabel.snp.right).offset(5)
            }
            

            wrap.addSubview(underline)
            underline.snp.makeConstraints{
                $0.bottom.equalTo(titleLabel.snp.top).offset(1)
                $0.left.equalToSuperview().inset(19)
                $0.size.equalTo(CGSize(width: 40, height: 2))
            }
            
            wrap.addSubview(regionLabel)
            regionLabel.snp.makeConstraints{
                $0.bottom.equalTo(underline.snp.top).offset(-0)
                $0.left.equalToSuperview().inset(20)
            }

            
        }

        func setUI(){
            backgroundColor = .systemGroupedBackground
            addSubview(wrap)
            setAutoLayout()
        }
    }

//
//    let review = ViewForReview()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.addSubview(review)
//        review.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    
//
//    var isBookmarked = false
//
//    private let view: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 12
//        view.clipsToBounds = true
//        return view
//    }()
//
//    var picture: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "photo")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.snp.makeConstraints { make in
//            make.height.equalToSuperview()
//        }
//        return imageView
//    }()
//
//    let title: UILabel = {
//        let label = UILabel()
//        label.text = "맛집명"
//        label.textAlignment = .left
//        label.font = FontGuide.size14Bold
//        label.textColor = .black
//        label.snp.makeConstraints { make in
//            make.height.equalTo(20)
//        }
//        return label
//    }()
//
//    let title2: UILabel = {
//        let label = UILabel()
//        label.text = "여긴 찐짜 맛있네요~ 지금껏 먹..."
//        label.textAlignment = .left
//        label.font = FontGuide.size14Bold
//        label.textColor = .black
//        label.snp.makeConstraints { make in
//            make.height.equalTo(20)
//        }
//        return label
//    }()
//
//    private lazy var titleStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [title, title2])
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.spacing = 0
//        return stackView
//    }()
//
//
//    let bookmark: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "bookMark"), for: .normal)
//        button.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
//        button.snp.makeConstraints { make in
//            make.width.equalTo(13.82)
//            make.height.equalTo(12)
//        }
//        return button
//    }()
//
//    @objc func bookmarkTapped() {
//        }
//}
//
//extension MainPageReviewCollectionViewCell {
//    func setupUI() {
//
//        view.addSubview(picture)
//        picture.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.height.equalToSuperview()
//        }
//
//        view.addSubview(titleStackView)
//        title.snp.makeConstraints { make in
//            make.top.equalTo(picture.snp.bottom).offset(12)
//            make.leading.equalToSuperview().offset(12)
//        }
//
//        view.addSubview(bookmark)
//        bookmark.snp.makeConstraints { make in
//            make.top.equalTo(title.snp.top).offset(5)
//            make.trailing.equalToSuperview().offset(-12)
//        }
//    }

