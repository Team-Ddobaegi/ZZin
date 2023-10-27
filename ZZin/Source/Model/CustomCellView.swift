//
//  CustomCellView.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/25/23.
//

import UIKit
import SnapKit
import Then



//MARK: - 추천 맛집 cell에 사용될 썸네일(UIView)

class RecommendPlaceThumbnail: UIView {
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Settings
    
    func setView(){
        configureUI()
    }
    
    
    // MARK: - Properties
    
    let wrap = UIView().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .systemBackground
    }
    
    let img = UIImageView().then{
        $0.image = UIImage(named: "ogudangdang.jpeg")
        $0.layer.cornerRadius = 15
        $0.layer.opacity = 0.4
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.text = "하남돼지집"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.numberOfLines = 0 // 글자 줄 제한 없음
        $0.textAlignment = .left
        $0.baselineAdjustment = .alignBaselines
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "분위기 좋은 돼지집"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 1 // 글자 줄 제한 없음
        $0.textAlignment = .left
        $0.baselineAdjustment = .none
    }
    
    
    // MARK: - Configure UI
    
    func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    func addSubViews(){
        addSubview(wrap)
        wrap.addSubview(img)
        wrap.addSubview(descriptionLabel)
        wrap.addSubview(titleLabel)
    }
    
    func setConstraints() {
        wrap.snp.makeConstraints{
            $0.edges.centerX.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 170, height: 228))
        }
        
        img.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview().inset(15)
        }
        
        titleLabel.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(15)
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-7)
        }
    }
    
}



//MARK: - 추천 맛집의 리뷰 cell에 사용될 썸네일(UIView)

class RecommendPlaceReviewThumbnail: UIView {
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Settings
    
    func setView(){
        configureUI()
    }
    
    
    // MARK: - Properties
    
    let wrap = UIView().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .black
    }
    
    let img = UIImageView().then{
        $0.image = UIImage(named: "ogudangdang_review.jpeg")
        $0.layer.cornerRadius = 15
        $0.layer.opacity = 0.4
        $0.clipsToBounds = true
        $0.contentMode = .scaleToFill
    }
    
    let reviewTitleLabel: UILabel = {
        let label = UILabel()
        let text = "식감도 맛도 너무 좋은 '삼겹살' 맛집, 하남돼지집"
        // 폰트 변경
        let font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        // 행간 조절
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        
        // 폰트 스타일 적용
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute(.font, value: font as Any, range: NSMakeRange(0, attributedText.length))
        
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    let regionLabel = UILabel().then {
        $0.text = "강남구" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .white
        $0.numberOfLines = 1 // 1줄로 제한
        $0.textAlignment = .left
        $0.baselineAdjustment = .alignBaselines
    }
    
    let withKeywordLabel = UILabel().then {
        $0.text = "#가족과 함께💜" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    let conditionKeywordLabel = UILabel().then {
        $0.text = "#고급 분위기🍷" // dummy 입니다. 각 VC에서 덮어써서 Custom 하세요.
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    let underline = UIView().then {
        $0.backgroundColor = ColorGuide.cherryTomato
    }
    
    
    // MARK: - ConfigureUI
    
    func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    func addSubViews(){
        addSubview(wrap)
        wrap.addSubview(img)
        wrap.addSubview(reviewTitleLabel)
        wrap.addSubview(withKeywordLabel)
        wrap.addSubview(conditionKeywordLabel)
        wrap.addSubview(regionLabel)
        wrap.addSubview(underline)
    }
    
    func setConstraints(){
        wrap.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        img.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        reviewTitleLabel.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview().inset(20)
        }
        
        withKeywordLabel.snp.makeConstraints{
            $0.top.equalTo(wrap.snp.top).offset(20)
            $0.left.equalTo(wrap.snp.left).offset(20)
        }
        
        conditionKeywordLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(20)
            $0.left.equalTo(withKeywordLabel.snp.right).offset(10)
        }
        
        regionLabel.snp.makeConstraints{
            $0.bottom.equalTo(underline.snp.top).offset(-5)
            $0.left.equalToSuperview().inset(20)
        }
        
        underline.snp.makeConstraints{
            $0.bottom.equalTo(reviewTitleLabel.snp.top).offset(-15)
            $0.left.equalTo(regionLabel.snp.left)
            $0.size.equalTo(CGSize(width: 47, height: 7))
        }
    }
}
