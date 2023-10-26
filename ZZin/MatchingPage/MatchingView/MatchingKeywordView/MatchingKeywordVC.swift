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


class MatchingKeywordVC: UIViewController {
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    
    // MARK: - Settings
    
    func setView() {
        view.backgroundColor = .white

        setButtonAttribute()
        configureUI()
    }
    
    func setButtonAttribute(){
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func updateInfoLabel(_ keywordType: KeywordType) {
        let selectedKeywords: [String]
        switch keywordType {
        case .with:
            selectedKeywords = selectedWithKeywords
        case .condition:
            selectedKeywords = selectedConditionKeywords
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
    
    
    
    
    // MARK: - Properties
    
    // 키워드타입 초기세팅
    var selectedKeywordType: KeywordType = .with
    
    // 각 키워드페이지에 맞춰 키워드 모델 호출
    let firstKeywords = Keyword().with
    let secondKeywords = Keyword().condition
    let menuKeywords = Keyword().menu
    
    // 선택된 셀의 개수를 추적하는 변수
    var selectedCellCount: Int = 0
    
    // 선택된 셀을 저장할 배열
    var selectedWithKeywords: [String] = []
    var selectedConditionKeywords: [String] = []
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
        $0.register(MatchingKeywordCell.self, forCellWithReuseIdentifier: MatchingKeywordCell.reuseIdentifer)
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
    
    
    // MARK: - Actions
    
    @objc func confirmButtonTapped() {
        print("확인 버튼이 눌렸습니다.")
        
        dismiss(animated: true)
    }
    
    
    // MARK: - ConfigureUI
    
    func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    func addSubViews() {
        [noticeLabel, userChoiceCollectionView, infoLabel, confirmButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(30)
        }
        
        userChoiceCollectionView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
}


// MARK: - CollectionView

extension MatchingKeywordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (userChoiceCollectionView.frame.width-20)/2, height: 50)
    }
}

extension MatchingKeywordVC: UICollectionViewDataSource {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingKeywordCell.reuseIdentifer, for: indexPath) as? MatchingKeywordCell
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

extension MatchingKeywordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
            print("인덱스 \(indexPath.row), \(cell.label.text ?? "") 클릭")
            
            switch selectedKeywordType {
            case .with, .condition, .menu:
                handleSelectionWithKeyword(cell, collectionView: collectionView)
                
                // 키워드 분위기, 메뉴 개수 제한
//            case .condition, .menu:
//                handleSelectionConditionAndMenuKeyword(cell)
            }
        }
    }
    
    // 셀을 선택하는 메서드
    private func selectCell(_ cell: MatchingKeywordCell) {
        cell.isSelectedCell = true
        cell.setView()
        selectedCellCount += 1
    }
    
    // 모든 셀을 선택 해제하는 메서드
    private func deselectAllCells(in collectionView: UICollectionView) {
        for visibleCell in collectionView.visibleCells {
            if let visibleKeywordCell = visibleCell as? MatchingKeywordCell {
                visibleKeywordCell.isSelectedCell = false
                visibleKeywordCell.setView()
            }
        }
        selectedCellCount = 0
    }
    
    private func handleSelectionWithKeyword(_ cell: MatchingKeywordCell, collectionView: UICollectionView) {
        // 이미 선택된 셀이 있을 때, 선택된 셀 해제
        if selectedCellCount >= 1 {
            deselectAllCells(in: collectionView)
        }
        // 선택된 셀의 테두리 색 전환, 선택된 셀 개수 증가
        selectCell(cell)
    }
    
    // "condition" 및 "menu" 키워드 타입에 대한 선택 처리 메서드
    private func handleSelectionConditionAndMenuKeyword(_ cell: MatchingKeywordCell) {
        // 선택된 셀의 최대 개수 3개로 제한
        if selectedCellCount < 3 {
                // 선택된 셀의 테두리 색 전환, 선택된 셀 개수 증가
                selectCell(cell)
            } else {
                // 이미 3개 선택된 경우, 경고 메시지 표시
                deselectAllCells(in: userChoiceCollectionView)
                infoLabel.text = "키워드는 세 개까지만 선택 가능합니다."
                infoLabel.textColor = .red
            }
    }
    
}
