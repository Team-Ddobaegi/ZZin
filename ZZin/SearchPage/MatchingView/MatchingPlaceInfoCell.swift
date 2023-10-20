//
//  MatchingRestaurantInfoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

class MatchingPlaceInfoCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddsubView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        $0.setTitle("전화하기", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.backgroundColor = .lightGray
        
        $0.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        let iconImage = UIImage(systemName: "phone.fill")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .darkGray
        $0.contentVerticalAlignment = .center
        
        let spacing: CGFloat = 40
        $0.titleEdgeInsets = UIEdgeInsets(top: spacing, left: 0, bottom: 0, right: 0)
        
        
    }
    
    let placeReviewButton = UIButton().then {
        $0.setTitle("리뷰쓰기", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.backgroundColor = .lightGray
        
        $0.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        
        let iconImage = UIImage(systemName: "square.and.pencil")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .darkGray
        $0.contentVerticalAlignment = .center
        
        let spacing: CGFloat = 40
        $0.titleEdgeInsets = UIEdgeInsets(top: spacing, left: 0, bottom: 0, right: 0)
    }
    
    let placeLikeButton = UIButton().then {
        $0.setTitle("가볼게요", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.backgroundColor = .lightGray
        
        $0.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        let iconImage = UIImage(systemName: "arrow.down.heart")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .darkGray
        $0.contentVerticalAlignment = .center

        let spacing: CGFloat = 40
        $0.titleEdgeInsets = UIEdgeInsets(top: spacing, left: 0, bottom: 0, right: 0)
    }
    
    lazy var placeButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeCallButton, placeReviewButton, placeLikeButton])
        stackView.axis = .horizontal
        stackView.spacing = 80
        
        return stackView
    }()
  
    //MARK: - Settings
    
    private func setAddsubView() {
        addSubview(view)
        view.addSubview(placeTitleLabel)
        view.addSubview(placeTypeLabel)
        view.addSubview(placeAddresseLabel)
        view.addSubview(divider)
        view.addSubview(placeMapView)
        view.addSubview(placeButtonStackView)
    }
    
    
    
    //MARK: - ConfigureUI
    
    private func configureUI(){
        setConstraints()
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
            $0.leading.equalTo(placeTitleLabel).offset(110)
        }
        
        placeAddresseLabel.snp.makeConstraints {
            $0.bottom.equalTo(placeTitleLabel).offset(25)
            $0.leading.equalToSuperview().offset(20)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.top.equalTo(placeAddresseLabel.snp.bottom).offset(20)
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
            $0.height.equalTo(50)
            $0.top.equalTo(placeMapView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview().offset(-2)
        }
        
    }
}
