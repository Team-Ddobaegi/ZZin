import UIKit
import SwiftUI
import SnapKit

class StoreCardView: UIView {

    private lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집 이름"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var placeCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집 카테고리"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private lazy var placeFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 상황, 가게 특성"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private lazy var placeRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 평점"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private lazy var placeReviewLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰수"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private lazy var placeImage: UIImageView = {
        let image = UIImage(named: "ogudangdang")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5

        addSubview(placeNameLabel)
        addSubview(placeCategoryLabel)
        addSubview(placeFilterLabel)
        addSubview(placeRatingLabel)
        addSubview(placeReviewLabel)
        addSubview(placeImage)
        
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeImage.snp.top)
            $0.leading.equalTo(placeImage.snp.trailing).offset(20)
            
        }
        
        placeCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(placeNameLabel)
        }
        
        placeFilterLabel.snp.makeConstraints {
            $0.top.equalTo(placeCategoryLabel.snp.bottom).offset(4)
            $0.leading.equalTo(placeNameLabel)
        }
        
        placeRatingLabel.snp.makeConstraints {
            $0.top.equalTo(placeFilterLabel.snp.bottom).offset(4)
            $0.leading.equalTo(placeNameLabel)
        }
        
        placeReviewLabel.snp.makeConstraints {
            $0.top.equalTo(placeRatingLabel.snp.top)
            $0.leading.equalTo(placeNameLabel.snp.trailing)
        }
        
        placeImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(75)
            $0.height.equalTo(75)
        }

    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct StoreCardView_Preview: PreviewProvider {
    static var previews: some View {
        StoreCardViewWrapper()
    }

    struct StoreCardViewWrapper: UIViewRepresentable {
        func makeUIView(context: Context) -> StoreCardView {
            return StoreCardView()
        }

        func updateUIView(_ uiView: StoreCardView, context: Context) {
            // Update the view if needed
        }
    }
}

#endif
