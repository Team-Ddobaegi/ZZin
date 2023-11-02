

import UIKit
import SnapKit
import Then

enum MatchingKeywordType {
    case companion       // 누구랑 가시나요?
    case condition  // 어떤 분위기를 원하시나요?
    case kindOfFood       // 메뉴는 무엇인가요?
}

// MatchingVC로 데이터 전달
protocol MatchingKeywordDelegate: AnyObject {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType)
}

class MatchingKeywordVC: UIViewController {
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setButtonAttribute()
        setCollectionViewAttribute()
    }

    
    // MARK: - Settings
    
    
    func setView() {
        view.backgroundColor = .white
        view.addSubview(matchingKeywordView)
       
        matchingKeywordView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setButtonAttribute(){
        matchingKeywordView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func setCollectionViewAttribute(){
        matchingKeywordView.collectionViewUI.delegate = self
        matchingKeywordView.collectionViewUI.dataSource = self
        matchingKeywordView.collectionViewUI.register(MatchingKeywordCell.self, forCellWithReuseIdentifier: MatchingKeywordCell.reuseIdentifer)

    }
    
    func updateInfoLabel(_ keywordType: MatchingKeywordType) {
        let selectedKeywords: [String]
        switch keywordType {
        case .companion:
            selectedKeywords = selectedCompanionMatchingKeywords
        case .condition:
            selectedKeywords = selectedConditionMatchingKeywords
        case .kindOfFood:
            selectedKeywords = selectedMenuMatchingKeywords
        }
        
        if selectedKeywords.isEmpty {
            matchingKeywordView.infoLabel.text = "보기를 선택해주세요."
            matchingKeywordView.infoLabel.textColor = ColorGuide.main
            
        } else {
            matchingKeywordView.infoLabel.text = selectedKeywords.joined(separator: ", ")
            matchingKeywordView.infoLabel.textColor = .black
            matchingKeywordView.confirmButton.isEnabled = true
            matchingKeywordView.confirmButton.backgroundColor = ColorGuide.main
        }
    }
    
    func sendData(data: [String], type: MatchingKeywordType){
        let keyword = data
        let type = type
        
        delegate?.updateKeywords(keyword: keyword, keywordType: type)
    }
    
    
    // MARK: - Actions
    
    @objc func confirmButtonTapped() {
        // 선택된 키워드 타입을 식별하여 처리
        switch selectedMatchingKeywordType {
        case .companion:
            sendData(data: selectedCompanionMatchingKeywords, type: .companion)
        case .condition:
            sendData(data: selectedConditionMatchingKeywords, type: .condition)
        case .kindOfFood:
            sendData(data: selectedMenuMatchingKeywords, type: .kindOfFood)
        }
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Properties
    
    weak var delegate: MatchingKeywordDelegate?
    var matchingKeywordView = MatchingKeywordView()

    // 선택된 키워드를 업데이트 시켜줄 배열
    var updateKeywords: [String] = []
    
    var selectedMatchingKeywordCells: [MatchingKeywordCell] = []        // 선택된 키워드를 저장할 배열
    
    // 키워드타입 초기세팅
    var selectedMatchingKeywordType: MatchingKeywordType = .companion
    
    // 각 키워드페이지에 맞춰 키워드 모델 호출
    let firstMatchingKeywords = Keyword().with
    let secondMatchingKeywords = Keyword().condition
    let menuMatchingKeywords = Keyword().menu
    
    // 선택된 셀의 개수를 추적하는 변수
    var selectedMatchingKeywordCellCount: Int = 0
    
    // 선택된 셀을 저장할 배열
    var selectedCompanionMatchingKeywords: [String] = []
    var selectedConditionMatchingKeywords: [String] = []
    var selectedMenuMatchingKeywords: [String] = []
}
    

    
// MARK: - CollectionView

extension MatchingKeywordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (matchingKeywordView.collectionViewUI.frame.width-20)/2, height: 50)
    }
}

extension MatchingKeywordVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedMatchingKeywordType {
        case .companion:
            return firstMatchingKeywords.count
            
        case .condition:
            return secondMatchingKeywords.count
            
        case .kindOfFood:
            return menuMatchingKeywords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingKeywordCell.reuseIdentifer, for: indexPath) as? MatchingKeywordCell
        else {
            return UICollectionViewCell()
        }
        switch selectedMatchingKeywordType {
        case .companion:
            cell.label.text = "\(firstMatchingKeywords[indexPath.item])"
            cell.keywordType = .companion
            
        case .condition:
            cell.label.text = "\(secondMatchingKeywords[indexPath.item])"
            cell.keywordType = .condition
            
        case .kindOfFood:
            cell.label.text = "\(menuMatchingKeywords[indexPath.item])"
            cell.keywordType = .kindOfFood
        }
        
        cell.keywordVC = self
        
        return cell
    }
}

extension MatchingKeywordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
            print("인덱스 \(indexPath.row), \(cell.label.text ?? "") 클릭")
            
            switch selectedMatchingKeywordType {
            case .companion, .condition, .kindOfFood:
                handleSelectionKeyword(cell, collectionView: collectionView)
            }
        }
    }
    
    // 셀을 선택하는 메서드
    private func selectCell(_ cell: MatchingKeywordCell) {
        cell.isSelectedCell = true
        cell.setView()
        selectedMatchingKeywordCellCount += 1
    }
    
    // 셀을 선택 해제하는 메서드
    private func deselectAllCells(in collectionView: UICollectionView) {
        for visibleCell in collectionView.visibleCells {
            if let visibleKeywordCell = visibleCell as? MatchingKeywordCell {
                visibleKeywordCell.isSelectedCell = false
                visibleKeywordCell.setView()
            }
        }
        selectedMatchingKeywordCellCount = 0
    }
    
    // 셀 한개 이상 선택시 :: 선택된 셀 선택해제 후 새로운 셀 선택
    private func handleSelectionKeyword(_ cell: MatchingKeywordCell, collectionView: UICollectionView) {
        if selectedMatchingKeywordCellCount >= 1 {
            deselectAllCells(in: collectionView)
        }
        // 선택된 셀의 테두리 색 전환, 선택된 셀 개수 증가
        selectCell(cell)
      
        // 선택된 셀의 값 저장
        selectedMatchingKeywordCells.append(cell)
    }
    
    
    // MARK: - companion(1개)/condition(3개)/menu(3개) 키워드 개수 제한 메서드
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
//            print("인덱스 \(indexPath.row), \(cell.label.text ?? "") 클릭")
//
//            switch selectedMatchingKeywordType {
//            case .with, .condition, .menu:
//                handleSelectionWithKeyword(cell, collectionView: collectionView)
//
//                // 키워드 분위기, 메뉴 개수 제한
//            case .condition, .menu:
//                handleSelectionConditionAndMenuKeyword(cell)
//            }
//        }
//    }
    
//    private func handleSelectionWithKeyword(_ cell: MatchingKeywordCell, collectionView: UICollectionView) {
//        // 이미 선택된 셀이 있을 때, 선택된 셀 해제
//        if selectedMatchingKeywordCellCount >= 1 {
//            deselectAllCells(in: collectionView)
//        }
//        // 선택된 셀의 테두리 색 전환, 선택된 셀 개수 증가
//        selectCell(cell)
//    }
    
//    // "condition" 및 "menu" 키워드 타입에 대한 선택 처리 메서드
//        private func handleSelectionConditionAndMenuKeyword(_ cell: MatchingKeywordCell) {
//            // 선택된 셀의 최대 개수 3개로 제한
//            if selectedCellCount < 3 {
//                    // 선택된 셀의 테두리 색 전환, 선택된 셀 개수 증가
//                    selectCell(cell)
//                } else {
//                    // 이미 3개 선택된 경우, 경고 메시지 표시
//                    deselectAllCells(in: userChoiceCollectionView)
//                    infoLabel.text = "키워드는 세 개까지만 선택 가능합니다."
//                    infoLabel.textColor = .red
//                }
//        }
    
}

