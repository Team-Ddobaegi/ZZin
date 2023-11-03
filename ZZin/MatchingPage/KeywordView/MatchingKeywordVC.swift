

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
    
    // MARK: - Properties
    
    weak var delegate: MatchingKeywordDelegate?
    var matchingKeywordView = MatchingKeywordView()
    
    // 키워드 타입 초기세팅
    var selectedMatchingKeywordType: MatchingKeywordType = .companion
    
    // 각 키워드 타입에 맞춰 키워드 모델 호출
    let companionKeywords = Keyword().companion
    let conditionKeywords = Keyword().condition
    let kindOfFoodKeywords = Keyword().kindOfFood
    
    // 선택된 셀의 개수를 추적하는 변수
    var selectedMatchingKeywordCellCount: Int = 0
    
    // 선택된 셀을 저장할 배열
    var selectedCompanionMatchingKeywords: [String] = []
    var selectedConditionMatchingKeywords: [String] = []
    var selectedKindOfFoodMatchingKeywords: [String] = []
    
    
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
            selectedKeywords = selectedKindOfFoodMatchingKeywords
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
    
    func selectedKeywords(_ keywordType: MatchingKeywordType) {
        var selectedKeywords: [String]
        var infoLabel = "\(matchingKeywordView.infoLabel.text ?? "")"
        
        switch keywordType {
        case .companion:
            selectedKeywords = selectedCompanionMatchingKeywords
            if selectedKeywords.contains(infoLabel) {
                if let index = selectedKeywords.firstIndex(of: infoLabel) {
                    selectedKeywords.remove(at: index)
                }
            }
            case .condition:
                selectedKeywords = selectedConditionMatchingKeywords
            if selectedKeywords.contains(infoLabel) {
                if let index = selectedKeywords.firstIndex(of: infoLabel) {
                    selectedKeywords.remove(at: index)
                }
            }
                case .kindOfFood:
                    selectedKeywords = selectedKindOfFoodMatchingKeywords
            if selectedKeywords.contains(infoLabel) {
                if let index = selectedKeywords.firstIndex(of: infoLabel) {
                    selectedKeywords.remove(at: index)
                }
            }
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
            sendData(data: selectedKindOfFoodMatchingKeywords, type: .kindOfFood)
        }
        self.dismiss(animated: true)
    }
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
            return companionKeywords.count
            
        case .condition:
            return conditionKeywords.count
            
        case .kindOfFood:
            return kindOfFoodKeywords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingKeywordCell.reuseIdentifer, for: indexPath) as? MatchingKeywordCell
        else {
            return UICollectionViewCell()
        }
        
        switch selectedMatchingKeywordType {
        case .companion:
            cell.label.text = "\(companionKeywords[indexPath.item])"
            cell.keywordType = .companion
            
        case .condition:
            cell.label.text = "\(conditionKeywords[indexPath.item])"
            cell.keywordType = .condition
            
        case .kindOfFood:
            cell.label.text = "\(kindOfFoodKeywords[indexPath.item])"
            cell.keywordType = .kindOfFood
            
        }
        cell.keywordVC = self
        
    
//        if indexPath.row == 0 {
//            collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
//            cell.isSelected = true
//        }
        
        return cell
    }
}

extension MatchingKeywordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
            print("인덱스 \(indexPath.row), \(cell.label.text ?? "") 클릭")
            
            guard let selectedCell = cell.label.text else { return }
            
//            switch selectedMatchingKeywordType {
//            case .companion: selectedKeywords(.companion)
//            case .condition: selectedKeywords(.condition)
//            case .kindOfFood: selectedKeywords(.kindOfFood)
//            }

            switch selectedMatchingKeywordType {
            case .companion:
                if selectedCompanionMatchingKeywords.contains(selectedCell) {
                    if let index = selectedCompanionMatchingKeywords.firstIndex(of: selectedCell) {
                        selectedCompanionMatchingKeywords.remove(at: index)
                    }
                } else {
                    selectedCompanionMatchingKeywords.append(selectedCell)
                }
            case .condition:
                if selectedConditionMatchingKeywords.contains(selectedCell) {
                    if let index = selectedConditionMatchingKeywords.firstIndex(of: selectedCell) {
                        cell.isSelected = false
                        selectedConditionMatchingKeywords.remove(at: index)
                    }
                } else {
                    selectedConditionMatchingKeywords.append(selectedCell)
                }
            case .kindOfFood:
                if selectedKindOfFoodMatchingKeywords.contains(selectedCell) {
                    if let index = selectedKindOfFoodMatchingKeywords.firstIndex(of: selectedCell) {
                        cell.isSelected = false
                        selectedKindOfFoodMatchingKeywords.remove(at: index)
                    }
                } else {
                    selectedKindOfFoodMatchingKeywords.append(selectedCell)
                }
            }
            
            selectedMatchingKeywordCellCount = selectedCompanionMatchingKeywords.count
            updateInfoLabel(selectedMatchingKeywordType)
            
            // 다시 선택 시 셀의 선택 상태를 반전시키기 위해 아래 라인 추가
            cell.isSelected = !cell.isSelected
        
            print("#$$#$#$#$#$", selectedMatchingKeywordCellCount)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
            
            guard let deselectCell = cell.label.text else { return }
            if selectedMatchingKeywordCellCount > 0 {
                switch selectedMatchingKeywordType {
                case .companion: selectedCompanionMatchingKeywords.removeAll()
                case .condition: selectedConditionMatchingKeywords.removeAll()
                case .kindOfFood: selectedKindOfFoodMatchingKeywords.removeAll()
                }
                selectedMatchingKeywordCellCount = 0
                updateInfoLabel(selectedMatchingKeywordType)

            }
            
        }
    }
   
}


