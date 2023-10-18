//
//  SearchView.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/16/23.
//

import UIKit
import SnapKit
import Then

class SearchView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Properties
    
    private let searchResultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.text = "3가지를 가진 맛집"
        $0.textColor = .black
    }
    
    private let searchTipLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "tip"
        $0.textColor = .systemRed
    }
    
    private let searchNotiLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "각 항목을 탭하면 다른 키워드를 선택할 수 있어요!"
        $0.textColor = .systemGray
    }
    
    private let firstKeywordButton = KeywordButton(title: "키워드")
    
    private let secondKeywordButton = KeywordButton(title: "키워드")
    
    private let menuKeywordButton = KeywordButton(title: "키워드")
    
    public let mapButton = UIButton().then {
        let iconImage = UIImage(systemName: "map")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemRed
    }
    
    public let setLocationButton = UIButton().then {
        $0.setTitle("서울 강동구", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        let iconImage = UIImage(systemName: "chevron.down")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemRed
        $0.semanticContentAttribute = .forceRightToLeft

        let spacing: CGFloat = 10
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    }
    
    private let divider1 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private let divider2 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    //MARK: - UI
    
    private func configureUI(){
        setUpView()
        setDividerConstraints()
        setLableConstraints()
        setButtonConstraints()
    }
    
    private func setUpView() {
        addSubview(setLocationButton)
        addSubview(divider1)
        addSubview(searchResultLabel)
        addSubview(searchTipLabel)
        addSubview(searchNotiLabel)
        addSubview(firstKeywordButton)
        addSubview(secondKeywordButton)
        addSubview(menuKeywordButton)
        addSubview(mapButton)
        addSubview(divider2)
    }
    
    private func setDividerConstraints() {
        // 지역 설정 버튼 아래 구분선
        divider1.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(setLocationButton).offset(10)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
        // 키워드 아래 구분선
        divider2.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(firstKeywordButton).offset(25)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
    }
    
    private func setLableConstraints() {
        // 서치 결과:: n가지를 가진 맛집
        searchResultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
        }
        // 서치 팁 레이블:: tip
        searchTipLabel.snp.makeConstraints {
            $0.bottom.equalTo(searchResultLabel).offset(30)
            $0.leading.equalToSuperview().offset(70)
        }
        // 서치 팁 문구:: 각 항목을 탭하면 .. ~
        searchNotiLabel.snp.makeConstraints{
            $0.bottom.equalTo(searchResultLabel).offset(30)
            $0.trailing.equalToSuperview().offset(-70)
        }
    }
    
    private func setButtonConstraints() {
        // 위치 설정 버튼
        setLocationButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
        }
        
        // 주변 맛집 버튼
        mapButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().offset(-20)
        }
       
        // 첫번째 키워드 버튼
        firstKeywordButton.snp.makeConstraints {
            $0.bottom.equalTo(searchNotiLabel).offset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        // 두번째 키워드 버튼
        secondKeywordButton.snp.makeConstraints {
            $0.bottom.equalTo(searchNotiLabel).offset(50)
            $0.centerX.equalToSuperview()
        }
        // 음식점 키워드 버튼
        menuKeywordButton.snp.makeConstraints {
            $0.bottom.equalTo(searchNotiLabel).offset(50)
            $0.trailing.equalToSuperview().offset(-25)
        }
    }
}
