import UIKit
import SnapKit

class StoreCardView: UIView {

    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집 이름"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var placeCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집 카테고리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var placeCompanionLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 동행자"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    lazy var placeConditionLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 특성"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    
    lazy var placeRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 평점"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    lazy var placeReviewLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰수"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    lazy var placeAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 주소"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    lazy var placeImage: UIImageView = {
//        let image = UIImage(named: "review_placeholder.png")
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeNameLabel, placeCategoryLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func updateStoreCardView(with review: Review, reviewCount: Int) {
            placeCategoryLabel.text = review.kindOfFood
            placeCompanionLabel.text = review.companion
            placeConditionLabel.text = review.condition
            placeRatingLabel.text = "찐농도 \(Int(review.rate))%"
            placeReviewLabel.text = "리뷰 (\(reviewCount))"
    }
    
    private func setupUI() {
        backgroundColor = .customBackground
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5

        addSubview(placeNameLabel)
        addSubview(placeCategoryLabel)
        addSubview(placeAddressLabel)
        addSubview(placeConditionLabel)
        addSubview(placeRatingLabel)
        addSubview(placeReviewLabel)
        addSubview(placeImage)
        addSubview(placeCompanionLabel)
        addSubview(labelsStackView)

        labelsStackView.snp.makeConstraints { make in
            make.top.equalTo(placeImage.snp.top)
            make.leading.equalTo(placeImage.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
        
        placeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(labelsStackView.snp.bottom).offset(4)
            $0.leading.equalTo(placeNameLabel)
        }
        
        placeCompanionLabel.snp.makeConstraints {
            $0.top.equalTo(placeAddressLabel.snp.bottom).offset(7)
            $0.leading.equalTo(placeNameLabel)
        }
        
        placeConditionLabel.snp.makeConstraints {
            $0.top.equalTo(placeCompanionLabel.snp.top)
            $0.leading.equalTo(placeCompanionLabel.snp.trailing).offset(10)
        }
        
        placeRatingLabel.snp.makeConstraints {
            $0.bottom.equalTo(placeImage.snp.bottom).offset(-2)
            $0.leading.equalTo(placeNameLabel)
        }
        
        placeReviewLabel.snp.makeConstraints {
            $0.top.equalTo(placeRatingLabel.snp.top)
            $0.leading.equalTo(placeRatingLabel.snp.trailing).offset(10)
        }
        
        placeImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(90)
        }

    }
}
