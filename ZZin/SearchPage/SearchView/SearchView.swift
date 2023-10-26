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
    
    var selectedKeywords: [String] = []

    private let searchResultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.text = "3가지를 가진 맛집"
        $0.textColor = .black
    }
    
    private let searchTipLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "tip"
        $0.textColor = ColorGuide.main
    }
    
    private let searchNotiLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "각 항목을 탭하면 다른 키워드를 선택할 수 있어요!"
        $0.textColor = .systemGray
    }
    
    
    let firstKeywordButton = UIButton().customButton(title: "키워드")

    let firstPlusIcon = UILabel().plus()
    
    let secondKeywordButton = UIButton().customButton(title: "키워드")
    
    let secondPlusIcon = UILabel().plus()
    
    let menuKeywordButton = UIButton().customButton(title: "키워드")
   
    
    lazy var keywordButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstKeywordButton,firstPlusIcon,secondKeywordButton,secondPlusIcon,menuKeywordButton])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        
        return stackView
    }()
    
    public let mapButton = UIButton().then {
        let iconImage = UIImage(systemName: "map")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = ColorGuide.cherryTomato
    }
    
    public let locationButton = UIButton().then {
        let iconImage = UIImage(systemName: "location")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = ColorGuide.cherryTomato
    }
    
    public let setLocationButton = UIButton().then {
        $0.setTitle("서울 강동구", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        let iconImage = UIImage(systemName: "chevron.down")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = ColorGuide.main
        $0.semanticContentAttribute = .forceRightToLeft

        let spacing: CGFloat = 10
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    }
    
    private let divider1 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    public let divider2 = UIView().then {
        $0.backgroundColor = .lightGray
    }
   
    
    //MARK: - UI
    
    private func configureUI(){
        addSubViews()
        setDividerConstraints()
        setLableConstraints()
        setButtonConstraints()
    }
    
    private func addSubViews() {
        [searchResultLabel, mapButton, locationButton, setLocationButton, searchTipLabel, searchNotiLabel, keywordButtonStackView, divider1, divider2 ].forEach { addSubview($0) }
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
            $0.bottom.equalTo(firstKeywordButton).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setLableConstraints() {
        // 서치 결과:: n가지를 가진 맛집
        searchResultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(115)
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
        
        // 현재 위치 버튼
        locationButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
        
        // 주변 맛집 버튼
        mapButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().offset(-20)
        }
       
        keywordButtonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
            $0.bottom.equalTo(searchNotiLabel).offset(50)

        }
        
    }
   
}


extension UIButton {
    func customButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemGray2, for: .normal)
        button.setTitleColor(ColorGuide.cherryTomato, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 40 / 2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(40)
        }
        return button
    }
}

extension UILabel {
    func plus() -> UILabel {
        let plus = UILabel()
        plus.text = "+"
        plus.textColor = .darkGray
        plus.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        plus.snp.makeConstraints {
            $0.width.height.equalTo(10)
        }
        return plus
    }
}

