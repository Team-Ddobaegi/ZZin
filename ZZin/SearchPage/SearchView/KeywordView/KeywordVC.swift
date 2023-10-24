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
    case with       // 누구랑 가시나요?
    case condition  // 어떤 분위기를 원하시나요?
    case menu       // 메뉴는 무엇인가요?
}

class KeywordVC: UIViewController {
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setConstraints()
        setButtonAttribute()
    }
    
    
    // MARK: - Properties
    
    // 키워드타입 초기세팅
    var selectedKeywordType: KeywordType = .with
    
    // 각 키워드페이지에 맞춰 키워드 모델 호출
    let firstKeywords = Keyword().with
    let secondKeywords = Keyword().condition
    let menuKeywords = Keyword().menu
    
    // 선택된 셀의 인덱스를 추적
    var selectedCellIndex: Int?
    
    // 선택된 셀을 저장할 배열
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
        $0.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifer)
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
    
    
    // MARK: - Settings
    
    func setView() {
        view.backgroundColor = .white
        [noticeLabel, userChoiceCollectionView, infoLabel, confirmButton].forEach { view.addSubview($0) }
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
            infoLabel.text = selectedFirstKeywords.joined(separator: ", ")
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.reuseIdentifer, for: indexPath) as? KeywordCell
        else {
            return UICollectionViewCell()
        }
        switch selectedKeywordType {
        case .with:
            cell.label.text = "\(firstKeywords[indexPath.item])"
            cell.keywordType = .with
            
        case .condition:
            cell.label.text = "\(secondKeywords[indexPath.item])"
            cell.keywordType = .condition
            
        case .menu:
            cell.label.text = "\(menuKeywords[indexPath.item])"
            cell.keywordType = .menu
        }
        
        cell.keywordVC = self
        
        return cell
    }
}

extension KeywordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? KeywordCell {
            print("index \(indexPath.row), \(cell.label.text ?? "") click ")
            // 선택된 셀의 테두리 색을 바꿔주는 로직
            cell.isSelectedCell = !cell.isSelectedCell
            cell.setView()
        }
    }
}
