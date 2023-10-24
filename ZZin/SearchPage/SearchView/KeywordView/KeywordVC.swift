//
//  KeywordPage.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/19.
//

import UIKit
import SnapKit
import Then

enum KeywordType {
    case with
    case condition
    case menu
}

class KeywordVC: UIViewController {
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setButtonAttribute()
    }
    
    // MARK: - Properties
    
    // 키워드타입 초기세팅
    var selectedKeywordType: KeywordType = .with
    
    let firstKeywords = Keyword().with
    let secondKeywords = Keyword().condition
    let menuKeywords = Keyword().menu
    
    var selectedCellIndex: Int? // 선택된 셀의 인덱스를 추적
    
    var selectedKeywords: [String] = [] // 선택된 셀을 저장할 배열
    
    var selectedFirstKeywords: [String] = []
    var selectedSecondKeywords: [String] = []
    var selectedMenuKeywords: [String] = []
    
    
    let noticeLabel = UILabel().then {
        $0.text = "누구랑\n가시나요?"
        $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private var layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 20
    }
    
    lazy var userChoiceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(KeywordCollectionViewCell.self, forCellWithReuseIdentifier: KeywordCollectionViewCell.reuseIdentifer)
    }
    
    var infoLabel = UILabel().then {
        $0.text = "보기를 선택해주세요."
        $0.textColor = ColorGuide.cherryTomato
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.backgroundColor = ColorGuide.cherryTomato
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    weak var searchView: SearchView?
    weak var searchVC: SearchVC?
    
    // MARK: - Settings
    
    func setView() {
        view.backgroundColor = .white
        [noticeLabel, userChoiceCollectionView, infoLabel, confirmButton].forEach { view.addSubview($0) }
        setConstraints()
    }
    
    func setButtonAttribute(){
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func updateInfoLabel(_ keywordType: KeywordType) {
        let selectedKeywords: [String]
            switch keywordType {
            case .with:
                selectedKeywords = selectedFirstKeywords
            case .condition:
                selectedKeywords = selectedSecondKeywords
            case .menu:
                selectedKeywords = selectedMenuKeywords
            }
            
            if selectedKeywords.isEmpty {
                infoLabel.text = "보기를 선택해주세요."
                infoLabel.textColor = ColorGuide.cherryTomato
            } else {
                infoLabel.text = selectedKeywords.joined(separator: ", ")
                infoLabel.textColor = .black
            }
    }
    
    
    // MARK: - Actions
    
    @objc func confirmButtonTapped() {
        print("확인 버튼이 눌렸습니다.")
        
        dismiss(animated: true)
    }
    
    
    // MARK: - ConfigureUI
    
    func setConstraints() {
        noticeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(100)
        }
        
        userChoiceCollectionView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-150)
            $0.leading.equalToSuperview().offset(25)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
    }
}


// MARK: - CollectionView

extension KeywordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (userChoiceCollectionView.frame.width-20)/2, height: 50)
    }
}

extension KeywordVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedKeywordType {
            
        case .with:
            return firstKeywords.count
            
        case .condition:
            return secondKeywords.count
            
        case .menu:
            return menuKeywords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.reuseIdentifer, for: indexPath) as! KeywordCollectionViewCell
        
        switch selectedKeywordType {
            
        case .with:
            cell.cellButton.setTitle(firstKeywords[indexPath.item], for: .normal)
            cell.keywordType = .with
            
        case .condition:
            cell.cellButton.setTitle(secondKeywords[indexPath.item], for: .normal)
            cell.keywordType = .condition
            
        case .menu:
            cell.cellButton.setTitle(menuKeywords[indexPath.item], for: .normal)
            cell.keywordType = .menu
        }
        
        cell.keywordVC = self
        
        return cell
    }
    
}

extension KeywordVC: UICollectionViewDelegate {
    
}
