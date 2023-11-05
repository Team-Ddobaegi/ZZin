

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
    
    // 선택 키워드 타입
    let keywordType: Keyword = Keyword()

    var selectedMatchingKeywordType: MatchingKeywordType = .companion
    
    // 각 키워드 타입에 맞춰 키워드 모델 호출
    let companionKeywords = Keyword().companion
    let conditionKeywords = Keyword().condition
    let kindOfFoodKeywords = Keyword().kindOfFood
    
    // 선택된 셀의 개수를 추적하는 변수
    var selectedKeywordsCount: Int = 0

    // 선택된 셀을 저장할 배열
    var selectedKeywords: [String] = []

    var selectedIndexPath: [IndexPath] = []
    
    
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
        matchingKeywordView.collectionViewUI.register(MatchingKeywordCell.self, forCellWithReuseIdentifier: MatchingKeywordCell.reuseIdentifer)
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
            sendData(data: selectedKeywords, type: .companion)
        case .condition:
            sendData(data: selectedKeywords, type: .condition)
        case .kindOfFood:
            sendData(data: selectedKeywords, type: .kindOfFood)
        }
        self.dismiss(animated: true)
        print("~~ \(selectedKeywords.last ?? "") 보낸다 ~!!~!~!~ ")
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
            return keywordType.companion.count
            
        case .condition:
            return keywordType.condition.count
            
        case .kindOfFood:
            return keywordType.kindOfFood.count
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
            cell.label.text = "\(keywordType.companion[indexPath.item])"
            cell.keywordType = .companion
            
        case .condition:
            cell.label.text = "\(keywordType.condition[indexPath.item])"
            cell.keywordType = .condition
            
        case .kindOfFood:
            cell.label.text = "\(keywordType.kindOfFood[indexPath.item])"
            cell.keywordType = .kindOfFood
        }
        
        for indexPath in selectedIndexPath {
            // 배열에 저장된 IndexPath에 따른 작업 수행
            if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
                // 선택된 셀에 대한 작업 수행
                cell.layer.borderColor = ColorGuide.main.cgColor
                matchingKeywordView.infoLabel.text = cell.label.text
                matchingKeywordView.infoLabel.textColor = .darkGray
            }
        }
        
        if !selectedIndexPath.isEmpty {
            print("ㅇㅇ", selectedIndexPath)
            guard indexPath == selectedIndexPath[0] else { return cell}
           
            cell.layer.borderColor = ColorGuide.main.cgColor
            matchingKeywordView.infoLabel.text = cell.label.text
            matchingKeywordView.infoLabel.textColor = .darkGray
        }
        
        return cell
    }
}

extension MatchingKeywordVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingKeywordCell.reuseIdentifer, for: indexPath) as! MatchingKeywordCell
        selectedIndexPath.append(indexPath)
        
        if selectedIndexPath.count > 1 {
            guard selectedIndexPath[0] != indexPath else {
                collectionView.deselectItem(at: selectedIndexPath[0], animated: true)
                matchingKeywordView.infoLabel.text = "보기를 선택해주세요."
                matchingKeywordView.infoLabel.textColor = ColorGuide.main
                selectedIndexPath = []
                collectionView.reloadData()
                return
            }
            collectionView.deselectItem(at: selectedIndexPath[0], animated: true)
            selectedIndexPath.remove(at: 0)
            print ("~~ 초기화 후 선택 키워드", selectedIndexPath)
        }
        collectionView.reloadData()

//        selectedKeywords.append(keywordType.companion[indexPath.item])
        
        switch selectedMatchingKeywordType {
        case .companion:
            return  selectedKeywords.append(keywordType.companion[indexPath.item])
        case .condition:
            return  selectedKeywords.append(keywordType.condition[indexPath.item])
        case .kindOfFood:
            return  selectedKeywords.append(keywordType.kindOfFood[indexPath.item])
        }
        
    }
}


//if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
//    
//    guard let selectedCell = cell.label.text else { return }
//    if cell.isSelected {
//        if let index = selectedKeywords.firstIndex(of: selectedCell) {
//            selectedKeywords.remove(at: index)
//            cell.setSelected(false, animated: true) // 선택된 셀의 중복선택 해제
//            cell.label.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
//            matchingKeywordView.infoLabel.text = "보기를 선택해주세요."
//            matchingKeywordView.infoLabel.textColor = ColorGuide.main
//            print("~~ 인덱스 \(indexPath.item), \(selectedCell) 선택해제")
//
//        } else {
//            selectedKeywords.append(selectedCell)
//            
//            cell.label.layer.borderColor = ColorGuide.main.cgColor
//
//            matchingKeywordView.infoLabel.text = selectedCell
//            matchingKeywordView.infoLabel.textColor = .darkGray
//            selectedIndexPath = indexPath
//            
//            print("~~ 제발", selectedIndexPath)
//            print("~~ 인덱스 \(indexPath.item), \(selectedCell) 선택")
//
//        }
//    }
//}
