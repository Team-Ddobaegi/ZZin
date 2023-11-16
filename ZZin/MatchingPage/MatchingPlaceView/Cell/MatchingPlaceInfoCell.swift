//
//  MatchingRestaurantInfoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

protocol MatchingPlaceInfoCellDelegate: MatchingPlaceVC {
    // 위임할 기능을 적는다.
    func touchUpCallButton()
    
    func touchUpReviewButton()
    
    func touchUpLikeButton()
}

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
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingRestaurantInfoCell"
    weak var delegate: MatchingPlaceInfoCellDelegate?

    let view = UIView().then {
        $0.backgroundColor = .customBackground
    }
    
    let placeTitleLabel = UILabel().then {
        $0.text = "하남돼지집"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .label
        $0.textAlignment = .left
    }
    
    let placeTypeLabel = UILabel().then {
        $0.text = "음식점"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.textColor = .systemGray
        $0.textAlignment = .left
    }
    
    let placeAddresseLabel = UILabel().then {
        $0.text = "서울특별시 강남구 어쩌고 저쩌고"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .systemGray
        $0.textAlignment = .left
    }
    
    let divider = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    let headerDivider = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
  
    let footerDivider = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    
    var placeCallButton = UIButton().then {
        let iconImage = UIImage(systemName: "phone.fill")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemGray
        $0.contentVerticalAlignment = .center
        $0.snp.makeConstraints{
            $0.width.height.equalTo(50)
        }
        $0.addTarget(MatchingPlaceInfoCell.self, action: #selector(didTappedButton), for: .touchUpInside)
    }
    
    var placeCallLabel = UILabel().then {
        $0.text = "전화하기"
        $0.textColor = .systemGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var callButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeCallButton, placeCallLabel])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    var placeReviewButton = UIButton().then {
        let iconImage = UIImage(systemName: "square.and.pencil")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemGray
        $0.contentVerticalAlignment = .center
        $0.isHighlighted = false
        $0.snp.makeConstraints{
            $0.width.height.equalTo(50)
        }
    }
    
    var placeReviewLabel = UILabel().then {
        $0.text = "리뷰쓰기"
        $0.textColor = .systemGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var reviewButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeReviewButton, placeReviewLabel])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    
    var placeMapButton = UIButton().then {
        let iconImage = UIImage(systemName: "map.fill")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemGray
        $0.contentVerticalAlignment = .center
        
        $0.snp.makeConstraints{
            $0.width.height.equalTo(50)
        }
    }
    
    var placeMapLabel = UILabel().then {
        $0.text = "위치 보기"
        $0.textColor = .systemGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var likeButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeMapButton, placeMapLabel])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    lazy var placeButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [callButtonStackView, reviewButtonStackView, likeButtonStackView])
        stackView.axis = .horizontal
//        stackView.spacing = 110
        stackView.spacing = 85 // 가볼래요 포함 스페이싱
        
        
        return stackView
    }()

    var colorChange: (() -> Void) = {}


    
    //MARK: - Settings
    
    private func setView(){
        configureUI()
        setButtonAttribute()
    }
    
    private func setButtonAttribute(){
        // Button Size Resizing
        placeCallButton.setImage(UIImage(systemName: "phone.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)
        placeReviewButton.setImage(UIImage(systemName: "square.and.pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)
        placeMapButton.setImage(UIImage(systemName: "map.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)

    }
    
    @objc func didTappedButton(_ sender: UIButton){
        colorChange()
    }
    
    
    //MARK: - ConfigureUI

    
    private func configureUI() {
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(view)
        contentView.addSubview(headerDivider)
        contentView.addSubview(footerDivider)
        view.addSubview(placeTitleLabel)
        view.addSubview(placeTypeLabel)
        view.addSubview(placeAddresseLabel)
        view.addSubview(divider)
        view.addSubview(placeButtonStackView)
    }
    
    private func setConstraints(){
        // 업체 정보를 보여줄 뷰
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerDivider.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(0.3)
        }
        
        footerDivider.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(0.3)
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        placeTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.left.equalTo(placeTitleLabel.snp.right).offset(10)
        }
        
        placeAddresseLabel.snp.makeConstraints {
            $0.bottom.equalTo(placeTitleLabel).offset(25)
            $0.leading.equalToSuperview().offset(20)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.3)
            $0.top.equalTo(placeAddresseLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        placeButtonStackView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(15)
            $0.centerX.equalToSuperview().offset(-2) // 중앙정렬이 아닌 것 같아서 살짝 옮겨놨음
        }
        
        divider.isHidden = true
    }
    
    
}
