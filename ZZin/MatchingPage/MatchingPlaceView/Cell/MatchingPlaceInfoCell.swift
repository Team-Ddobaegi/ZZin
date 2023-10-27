//
//  MatchingRestaurantInfoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then


//MARK: - 매칭 업체 정보가 나오는 TableView Cell

class MatchingPlaceInfoCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Settings
    
    private func setView(){
        configureUI()
        setButtonAttribute()
    }
    
    private func setButtonAttribute(){
        // Button Size Resizing
        placeCallButton.setImage(UIImage(systemName: "phone.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)
        placeReviewButton.setImage(UIImage(systemName: "square.and.pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)
        placeLikeButton.setImage(UIImage(systemName: "arrow.down.heart")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)

        // Button Click Effect
        placeCallButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        placeReviewButton.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
        placeLikeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func changeButtonColor(button: UIButton, label: UILabel, tintColor: UIColor) {
        button.tintColor = tintColor
        label.textColor = tintColor
    }
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingRestaurantInfoCell"
    
    let view = UIView().then {
        $0.backgroundColor = .white
    }
    
    let placeTitleLabel = UILabel().then {
        $0.text = "하남돼지집"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    let placeTypeLabel = UILabel().then {
        $0.text = "돼지고기집"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.textColor = .gray
        $0.textAlignment = .left
    }
    
    let placeAddresseLabel = UILabel().then {
        $0.text = "서울특별시 강남구 어쩌고 저쩌고"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .gray
        $0.textAlignment = .left
    }
    
    let divider = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let placeMapView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    let placeCallButton = UIButton().then {
        let iconImage = UIImage(systemName: "phone.fill")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .darkGray
        $0.contentVerticalAlignment = .center
        $0.snp.makeConstraints{
            $0.width.height.equalTo(50)
        }
    }
    
    let placeCallLabel = UILabel().then {
        $0.text = "전화하기"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var callButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeCallButton, placeCallLabel])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let placeReviewButton = UIButton().then {
        let iconImage = UIImage(systemName: "square.and.pencil")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .darkGray
        $0.contentVerticalAlignment = .center
        $0.snp.makeConstraints{
            $0.width.height.equalTo(50)
        }
    }
    
    let placeReviewLabel = UILabel().then {
        $0.text = "리뷰쓰기"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var reviewButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeReviewButton, placeReviewLabel])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    
    let placeLikeButton = UIButton().then {
        let iconImage = UIImage(systemName: "arrow.down.heart")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .darkGray
        $0.contentVerticalAlignment = .center
        
        $0.snp.makeConstraints{
            $0.width.height.equalTo(50)
        }
    }
    
    let placeLikeLabel = UILabel().then {
        $0.text = "가볼게요"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var likeButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeLikeButton, placeLikeLabel])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    lazy var placeButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [callButtonStackView, reviewButtonStackView,likeButtonStackView])
        stackView.axis = .horizontal
        stackView.spacing = 85
        
        
        return stackView
    }()
    
    
    
    //MARK: - Actions
    
    @objc func callButtonTapped(){
        print("전화하기 버튼 클릭")
        changeButtonColor(button: placeCallButton, label: placeCallLabel, tintColor: ColorGuide.main)
    }

    @objc func reviewButtonTapped() {
        print("리뷰쓰기 버튼 클릭")
        changeButtonColor(button: placeReviewButton, label: placeReviewLabel, tintColor: ColorGuide.main)
    }
    
    @objc func likeButtonTapped() {
        print("가볼래요 버튼 클릭")
        changeButtonColor(button: placeLikeButton, label: placeLikeLabel, tintColor: ColorGuide.main)
    }
    
    
    //MARK: - ConfigureUI
    
    private func configureUI() {
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(view)
        view.addSubview(placeTitleLabel)
        view.addSubview(placeTypeLabel)
        view.addSubview(placeAddresseLabel)
        view.addSubview(divider)
        view.addSubview(placeMapView)
        view.addSubview(placeButtonStackView)
    }
    
    private func setConstraints(){
        // 업체 정보를 보여줄 뷰
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        placeTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.left.equalTo(placeTitleLabel.snp.right).offset(20)
        }
        
        placeAddresseLabel.snp.makeConstraints {
            $0.bottom.equalTo(placeTitleLabel).offset(25)
            $0.leading.equalToSuperview().offset(20)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.top.equalTo(placeAddresseLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        placeMapView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.top.equalTo(divider.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        placeButtonStackView.snp.makeConstraints {
            $0.top.equalTo(placeMapView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview().offset(-2) // 중앙정렬이 아닌 것 같아서 살짝 옮겨놨음
        }

        
    }
    
    
}
