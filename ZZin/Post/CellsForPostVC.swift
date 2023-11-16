//
//  PostTableViewCell.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/25.
//

import UIKit
import SnapKit
import Then
import PhotosUI

class textInputCell: UICollectionViewCell, UITextFieldDelegate {
    
    static let identifier = "textInputCell"
    var buttonAction: (() -> Void) = {}

    
    // heading 모음
    let placeInfoHeading = SecondHeading().then{$0.label.text = "맛집 정보 입력"}
    let reviewInfoHeading = SecondHeading().then{$0.label.text = "리뷰 정보 입력"}
    
    // label title 모음
    let placeNameLabel = Title().then{$0.label.text = "가게 이름"}
    let placeAddressLabel = Title().then{$0.label.text = "가게 주소"}
    let placeTelLabel = Title().then{$0.label.text = "가게 연락처"}
    let reviewTitleLabel = Title().then{$0.label.text = "제목"}
    let reviewPhotoLabel = Title().then{$0.label.text = "후기 사진"}
    let keywordLabel = Title().then{$0.label.text = "방문한 음식점은 어땠나요?"}
    let reviewContentLabel = Title().then{$0.label.text = "방문 후기"}
        
    // textField 모음
    let placeNameField = CustomTextField()
    let placeAddressField = CustomTextField()
    let placeTelNumField = CustomTextField()
    let reviewTitleField = CustomTextField().then{
        $0.textField.placeholder = "리뷰 제목을 입력해주세요."
        $0.textField.isUserInteractionEnabled = true
        $0.textField.clearButtonMode = .whileEditing
    }
    
    // 장소 검색 버튼
    var findPlaceButton = UIButton().then{
        $0.layer.cornerRadius = 15
        $0.setTitleShadowColor(.systemGray, for: .selected)
        $0.backgroundColor = ColorGuide.main
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("  🔍 맛집 정보 확인  ", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final func textFieldDidEndEditing(_ textField: UITextField) -> String {
        titleText = textField.text ?? ""
        print("titleText :", titleText)
        
        return titleText ?? ""
    }

    
    func setupUI() {
        contentView.addSubview(placeInfoHeading)
        placeInfoHeading.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(findPlaceButton)
        findPlaceButton.snp.makeConstraints{
            $0.centerY.equalTo(placeInfoHeading)
            $0.left.equalTo(placeInfoHeading.snp.right).offset(16)
        }
        
        contentView.addSubview(placeNameLabel)
        placeNameLabel.snp.makeConstraints{
            $0.top.equalTo(placeInfoHeading.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(placeNameField)
        placeNameField.snp.makeConstraints{
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }

        contentView.addSubview(placeAddressLabel)
        placeAddressLabel.snp.makeConstraints{
            $0.top.equalTo(placeNameField.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(placeAddressField)
        placeAddressField.snp.makeConstraints{
            $0.top.equalTo(placeAddressLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(placeTelLabel)
        placeTelLabel.snp.makeConstraints{
            $0.top.equalTo(placeAddressField.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(placeTelNumField)
        placeTelNumField.snp.makeConstraints{
            $0.top.equalTo(placeTelLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(reviewInfoHeading)
        reviewInfoHeading.snp.makeConstraints{
            $0.top.equalTo(placeTelNumField.snp.bottom).offset(32)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(reviewTitleLabel)
        reviewTitleLabel.snp.makeConstraints{
            $0.top.equalTo(reviewInfoHeading.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(reviewTitleField)
        reviewTitleField.snp.makeConstraints{
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(reviewPhotoLabel)
        reviewPhotoLabel.snp.makeConstraints{
            $0.top.equalTo(reviewTitleField.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
    }
}

class ImgSelectionCell: UICollectionViewCell {

    static let identifier = "ImgSelectionCell"

    var imageView = UIImageView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    var countLabel = UILabel().then{
        $0.textColor = ColorGuide.main
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.text = "0 / 5"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .quaternarySystemFill
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SelectKeywordCell: UICollectionViewCell, UITextViewDelegate {
    
    static let identifier = "SelectKeywordsTableViewCell"
    let matchingView = MatchingView()

    var firstKeywordButton = UIButton()
    var secondKeywordButton = UIButton()
    var menuKeywordButton = UIButton()

    let titleLabel = Title().then{$0.label.text = "키워드 선정"}
    let contentLabel = Title().then{$0.label.text = "상세 후기"}
    let placeHolderLabel = UILabel().then{
        $0.text = "당신의 맛집에 대해서 설명해주세요."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .systemGray2
    }

    let infoLabel = UILabel().then{
        $0.text = "3가지를 가진 맛집"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .white
    }

    let searchNotiLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "각 항목을 탭하면 다른 키워드를 선택할 수 있어요!"
        $0.textColor = .systemGray
    }

    let searchTipLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "tip"
        $0.textColor = ColorGuide.main
    }
    
    // textView
    var textView = UITextView().then {
        $0.backgroundColor = .quaternarySystemFill
        $0.layer.cornerRadius = 15
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    // 제출 button
    var submitButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.setTitle("제출", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemGray3
        $0.layer.cornerRadius = 15
        $0.isUserInteractionEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setKeywordButton()
        setLayout()
        textView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.left.equalToSuperview()
        }

        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        contentView.addSubview(searchNotiLabel)
        searchNotiLabel.snp.makeConstraints{
            $0.top.equalTo(infoLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview().offset(4)
        }

        contentView.addSubview(searchTipLabel)
        searchTipLabel.snp.makeConstraints{
            $0.centerY.equalTo(searchNotiLabel)
            $0.right.equalTo(searchNotiLabel.snp.left).offset(-4)
        }

        contentView.addSubview(firstKeywordButton)
        firstKeywordButton.snp.makeConstraints{
            $0.top.equalTo(searchNotiLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(10)
        }

        contentView.addSubview(secondKeywordButton)
        secondKeywordButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(firstKeywordButton)
        }

        contentView.addSubview(menuKeywordButton)
        menuKeywordButton.snp.makeConstraints{
            $0.top.equalTo(searchNotiLabel.snp.bottom).offset(16)
            $0.right.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(menuKeywordButton.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints{
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints{
            $0.top.equalTo(textView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        contentView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints{
            $0.top.left.equalTo(textView).offset(8)
        }
    }
    func setKeywordButton() {
        firstKeywordButton = matchingView.companionKeywordButton
        secondKeywordButton = matchingView.conditionKeywordButton
        menuKeywordButton = matchingView.kindOfFoodKeywordButton
    }
}

extension SelectKeywordCell {
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text as Any)
        textViewText = textView.text
        print(textViewText as Any)
        
        if textView.text.count > 0 {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
        
        
    }


}

