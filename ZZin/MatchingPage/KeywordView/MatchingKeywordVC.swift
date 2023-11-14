

import UIKit
import SnapKit
import Then

enum MatchingKeywordType {
    case companion       // 누구랑 가시나요?
    case condition  // 어떤 분위기를 원하시나요?
    case kindOfFood       // 메뉴는 무엇인가요?
}

struct KeywordInfo {
    var keywords: [String]
    var selectedIndexPath: [IndexPath]
}

// MatchingVC로 데이터 전달
protocol MatchingKeywordDelegate: AnyObject {
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType, indexPath: [IndexPath])
}


class MatchingKeywordVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MatchingKeywordDelegate?
    var matchingKeywordView = MatchingKeywordView()
    
    // 선택 키워드 타입
    var selectedMatchingKeywordType: MatchingKeywordType = .companion
    
    // 각 키워드 타입에 맞춰 키워드 모델 호출
    let companionKeywords = Keyword().companion
    let conditionKeywords = Keyword().condition
    let kindOfFoodKeywords = Keyword().kindOfFood

    // 선택된 셀을 저장할 배열
    var selectedIndexPath: [IndexPath] = []
  
    var selectedCompanionIndexPath: [IndexPath] = []
    var selectedConditionIndexPath: [IndexPath] = []
    var selectedKindOfFoodIndexPath: [IndexPath] = []
    
    var selectedCompanionKeyword: [String] = []
    var selectedConditionKeyword: [String] = []
    var selectedKindOfFoodKeyword: [String] = []
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setButtonAttribute()
        setCollectionViewAttribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        matchingKeywordView.collectionViewUI.reloadData()
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
        matchingKeywordView.collectionViewUI.showsVerticalScrollIndicator = false
        matchingKeywordView.collectionViewUI.register(MatchingKeywordCell.self, forCellWithReuseIdentifier: MatchingKeywordCell.reuseIdentifer)
    }
    
    func sendData(data: [String], type: MatchingKeywordType, indexPath: [IndexPath]){
        let keyword = data
        let type = type
        let indexPath = indexPath
        
        delegate?.updateKeywords(keyword: keyword, keywordType: type, indexPath: indexPath)
    }
   
    
    // MARK: - Actions
    
    @objc func confirmButtonTapped() {
        // 선택된 키워드 타입을 식별하여 처리
        switch selectedMatchingKeywordType {
        case .companion:
            sendData(data: selectedCompanionKeyword, type: .companion, indexPath: selectedCompanionIndexPath)
            print("~~ \(selectedCompanionIndexPath) 보낸다 ~!!~!~!~ ")

        case .condition:
            sendData(data: selectedConditionKeyword, type: .condition, indexPath: selectedConditionIndexPath)
            print("~~ \(selectedConditionIndexPath) 보낸다 ~!!~!~!~ ")

        case .kindOfFood:
            sendData(data: selectedKindOfFoodKeyword, type: .kindOfFood, indexPath: selectedKindOfFoodIndexPath)
            print("~~ \(selectedKindOfFoodIndexPath) 보낸다 ~!!~!~!~ ")
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
        // 각 키워드에 맞는 키워드 배열
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
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        
        switch selectedMatchingKeywordType {
        case .companion:
            cell.label.text = "\(companionKeywords[indexPath.item])"
           
            for indexPath in selectedCompanionIndexPath {
                // 배열에 저장된 IndexPath에 따른 작업 수행
                if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
                    // 선택된 셀에 대한 작업 수행
                    cell.layer.borderColor = ColorGuide.main.cgColor
                    matchingKeywordView.infoLabel.text = cell.label.text
                    matchingKeywordView.infoLabel.textColor = .darkGray
                }
            }
            
            if !selectedCompanionIndexPath.isEmpty {
                guard indexPath == selectedCompanionIndexPath[0] else { return cell}
               
                cell.layer.borderColor = ColorGuide.main.cgColor
                matchingKeywordView.infoLabel.text = cell.label.text
                matchingKeywordView.infoLabel.textColor = .darkGray
            }
            
        case .condition:
            cell.label.text = "\(conditionKeywords[indexPath.item])"
            
            for indexPath in selectedConditionIndexPath {
                // 배열에 저장된 IndexPath에 따른 작업 수행
                if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
                    // 선택된 셀에 대한 작업 수행
                    cell.layer.borderColor = ColorGuide.main.cgColor
                    matchingKeywordView.infoLabel.text = cell.label.text
                    matchingKeywordView.infoLabel.textColor = .darkGray
                }
            }
            
            if !selectedConditionIndexPath.isEmpty {
                guard indexPath == selectedConditionIndexPath[0] else { return cell}
               
                cell.layer.borderColor = ColorGuide.main.cgColor
                matchingKeywordView.infoLabel.text = cell.label.text
                matchingKeywordView.infoLabel.textColor = .darkGray
            }
            
        case .kindOfFood:
            cell.label.text = "\(kindOfFoodKeywords[indexPath.item])"
            
            for indexPath in selectedKindOfFoodIndexPath {
                // 배열에 저장된 IndexPath에 따른 작업 수행
                if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
                    // 선택된 셀에 대한 작업 수행
                    cell.layer.borderColor = ColorGuide.main.cgColor
                    matchingKeywordView.infoLabel.text = cell.label.text
                    matchingKeywordView.infoLabel.textColor = .darkGray
                }
            }
            
            if !selectedKindOfFoodIndexPath.isEmpty {
                guard indexPath == selectedKindOfFoodIndexPath[0] else { return cell}
               
                cell.layer.borderColor = ColorGuide.main.cgColor
                matchingKeywordView.infoLabel.text = cell.label.text
                matchingKeywordView.infoLabel.textColor = .darkGray
            }
        }
     
        return cell
    }
}

extension MatchingKeywordVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingKeywordCell.reuseIdentifer, for: indexPath) as! MatchingKeywordCell
   
        collectionView.reloadData()

        switch selectedMatchingKeywordType {
        case .companion:
            selectedCompanionKeyword.append(companionKeywords[indexPath.item])
            selectedCompanionIndexPath.append(indexPath)
            
            if selectedCompanionIndexPath.count > 1 {
                guard selectedCompanionIndexPath[0] != indexPath else {
                    collectionView.deselectItem(at: selectedCompanionIndexPath[0], animated: true)
                    matchingKeywordView.infoLabel.text = "보기를 선택해주세요."
                    matchingKeywordView.infoLabel.textColor = ColorGuide.main
                    selectedCompanionIndexPath = []
                    selectedCompanionKeyword = []
                    collectionView.reloadData()
                    return
                }
                collectionView.deselectItem(at: selectedCompanionIndexPath[0], animated: true)
                selectedCompanionIndexPath.removeAll()
            }
            
            print("~~ companion 인덱스패스 전달합니두", selectedCompanionIndexPath.last!)
            
        case .condition:
            selectedConditionKeyword.append(conditionKeywords[indexPath.item])
            selectedConditionIndexPath.append(indexPath)
            
            if selectedConditionIndexPath.count > 1 {
                guard selectedConditionIndexPath[0] != indexPath else {
                    collectionView.deselectItem(at: selectedConditionIndexPath[0], animated: true)
                    matchingKeywordView.infoLabel.text = "보기를 선택해주세요."
                    matchingKeywordView.infoLabel.textColor = ColorGuide.main
                    selectedConditionIndexPath = []
                    selectedConditionKeyword = []
                    collectionView.reloadData()
                    return
                }
                collectionView.deselectItem(at: selectedConditionIndexPath[0], animated: true)
                selectedConditionIndexPath.remove(at: 0)
            }
            
            print("~~ condition 인덱스패스 전달합니두", selectedConditionIndexPath.last!)


        case .kindOfFood:
            selectedKindOfFoodKeyword.append(kindOfFoodKeywords[indexPath.item])
            selectedKindOfFoodIndexPath.append(indexPath)
            
            if selectedKindOfFoodIndexPath.count > 1 {
                guard selectedKindOfFoodIndexPath[0] != indexPath else {
                    collectionView.deselectItem(at: selectedKindOfFoodIndexPath[0], animated: true)
                    matchingKeywordView.infoLabel.text = "보기를 선택해주세요."
                    matchingKeywordView.infoLabel.textColor = ColorGuide.main
                    selectedKindOfFoodIndexPath = []
                    selectedKindOfFoodKeyword = []
                    collectionView.reloadData()
                    return
                }
                collectionView.deselectItem(at: selectedKindOfFoodIndexPath[0], animated: true)
                selectedKindOfFoodIndexPath.remove(at: 0)
            }
            
            print("~~ kindOfFood 인덱스패스 전달합니두", selectedKindOfFoodIndexPath.last!)
        }
        
    }
}
