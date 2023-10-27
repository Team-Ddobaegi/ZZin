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
    
    let reviewUiView = RecommendPlaceReviewThumbnail()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init 오류")
    }
    
    
    func setUI(){
        backgroundColor = .systemGroupedBackground
        addSubview(reviewUiView)
                reviewUiView.snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
        //        reviewUiView.reviewTitleLabel.font = FontGuide.size19Bold
        //        reviewUiView.reviewTitleLabel.textAlignment = .left
        //        reviewUiView.reviewTitleLabel.baselineAdjustment = .alignBaselines
        //        reviewUiView.reviewTitleLabel.attributedText
        //
        //
        //        reviewUiView.img.snp.makeConstraints {
        //            $0.edges.equalToSuperview()
        //        }
        //
        //        reviewUiView.reviewTitleLabel.snp.makeConstraints {
        //                            $0.bottom.equalToSuperview()
        //                            $0.left.equalToSuperview().offset(20)
        //                            $0.size.equalTo(CGSize(width: 300, height: 55))
        //        }
        //
        //        reviewUiView.withKeywordLabel.snp.makeConstraints {
        //            $0.top.equalToSuperview().inset(10)
        //                            $0.left.equalToSuperview().offset(20)
        //        }
        //
        //        reviewUiView.conditionKeywordLabel.snp.makeConstraints {
        //                            $0.top.equalToSuperview().inset(10)
        //            $0.left.equalTo(reviewUiView.withKeywordLabel.snp.right).offset(5)
        //        }
        //
        //        reviewUiView.regionLabel.snp.makeConstraints {
        //            $0.bottom.equalTo(reviewUiView.underline.snp.top).offset(0)
        //            $0.leading.equalToSuperview().inset(20)
        //        }
        //
        //        reviewUiView.underline.snp.makeConstraints {
        //            $0.bottom.equalTo(reviewUiView.reviewTitleLabel.snp.top).offset(-15)
        //                            $0.left.equalToSuperview().inset(19)
        //                            $0.size.equalTo(CGSize(width: 40, height: 10))
        //        }
        //
        //
        //
        //    }
    }
    
    ////    class ViewForReview: UIView {
    //        override init(frame: CGRect) {
    //            super.init(frame: frame)
    //            setUI()
    //        }
    //
    //        required init?(coder aDecoder: NSCoder) {
    //            fatalError("init(coder:) has not been implemented")
    //        }
    //
    //        let wrap = UIView().then {
    ////            $0.layer.cornerRadius = 50
    //            $0.clipsToBounds = true
    //
    //            $0.backgroundColor = .black
    //        }
    //
    //    let img = UIImageView().then{
    ////        imageView.image = UIImage(named: "")
    //        $0.backgroundColor = ColorGuide.subButton
    //        $0.layer.opacity = 0.4
    //        $0.clipsToBounds = true
    //    }
    //
    //
    //        let titleLabel = UILabel().then {
    //            $0.text = "삼겹살의 근본,\n구워주는 고기집 \"하남돼지집\""
    //            $0.font = FontGuide.size19Bold
    //            $0.textColor = .white
    //            $0.numberOfLines = 2 // 2줄로 제한
    //            $0.textAlignment = .left
    //            $0.baselineAdjustment = .alignBaselines
    //        }
    //
    //        let regionLabel = UILabel().then {
    //            $0.text = "강남구" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
    //            $0.font = FontGuide.size14Bold
    //            $0.textColor = .white
    //            $0.numberOfLines = 1 // 1줄로 제한
    //            $0.textAlignment = .left
    //            $0.baselineAdjustment = .alignBaselines
    //        }
    //
    //        let companyLabel = UILabel().then {
    //            $0.text = "#회식 장소로 제격🍺" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
    //            $0.font = FontGuide.size14
    //            $0.textColor = .white
    //        }
    //
    //        let conditionLabel = UILabel().then {
    //            $0.text = "#직접 손질해주는🥓" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
    //            $0.font = FontGuide.size14
    //            $0.textColor = .white
    //        }
    //
    //
    //        let underline = UIView().then {
    //            $0.backgroundColor = UIColor(red: 226, green: 58, blue: 37, alpha: 1.0)
    //        }
    //
    
    // ---------------------------------------------------------------------------------------
    //-----------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------
    //        func setAutoLayout() {
    //            wrap.snp.makeConstraints{
    //                $0.edges.centerX.centerY.equalToSuperview()
    //                $0.size.equalTo(CGSize(width: 353, height: 237))
    //            }
    //
    //            wrap.addSubview(img)
    //            img.snp.makeConstraints{
    //                $0.edges.equalToSuperview()
    //            }
    //
    //            wrap.addSubview(titleLabel)
    //            titleLabel.snp.makeConstraints{
    //                $0.bottom.equalToSuperview().inset(6)
    //                $0.left.equalToSuperview().offset(20)
    //
    //                $0.size.equalTo(CGSize(width: 300, height: 60))
    //            }
    //
    //            wrap.addSubview(companyLabel)
    //            companyLabel.snp.makeConstraints{
    //                $0.top.equalTo(wrap.snp.top).offset(10)
    //                $0.left.equalTo(wrap.snp.left).offset(20)
    //            }
    //
    //            wrap.addSubview(conditionLabel)
    //            conditionLabel.snp.makeConstraints{
    //                $0.top.equalToSuperview().inset(10)
    //                $0.left.equalTo(companyLabel.snp.right).offset(5)
    //            }
    //
    //
    //            wrap.addSubview(underline)
    //            underline.snp.makeConstraints{
    //                $0.bottom.equalTo(titleLabel.snp.top).offset(1)
    //                $0.left.equalToSuperview().inset(19)
    //                $0.size.equalTo(CGSize(width: 40, height: 2))
    //            }
    //
    //            wrap.addSubview(regionLabel)
    //            regionLabel.snp.makeConstraints{
    //                $0.bottom.equalTo(underline.snp.top).offset(-0)
    //                $0.left.equalToSuperview().inset(20)
    //            }
    //
    //
    //        }
    //
    //        func setUI(){
    //            backgroundColor = .systemGroupedBackground
    //            addSubview(wrap)
    //            setAutoLayout()
    //        }
}
