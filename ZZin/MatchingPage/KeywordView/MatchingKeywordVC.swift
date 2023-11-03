

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
    
    // 선택 키워드 타입 초기세팅
    var selectedMatchingKeywordType: MatchingKeywordType = .companion
    
    // 각 키워드 타입에 맞춰 키워드 모델 호출
    let companionKeywords = Keyword().companion
    let conditionKeywords = Keyword().condition
    let kindOfFoodKeywords = Keyword().kindOfFood
    
    // 선택된 셀의 개수를 추적하는 변수
    var selectedKeywordsCount: Int = 0

    // 선택된 셀을 저장할 배열
    var selectedKeywords: [String] = []

    
    
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
        print("~~ \(selectedKeywords) 보낸다 ~!!~!~!~ ")
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
        
        if let lastSelectedKeyword = selectedKeywords.last {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                cell.setSelected(true, animated: false)
                cell.label.layer.borderColor = ColorGuide.main.cgColor

                matchingKeywordView.infoLabel.text = cell.label.text
                matchingKeywordView.infoLabel.textColor = .darkGray
            
            print("~~ 마지막으로 선택된 키워드 맞나여? \(lastSelectedKeyword)")

            } else {
                cell.setSelected(false, animated: false)
                cell.label.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                print("~~ 선택된 키워드가 없다!")
            }

        return cell
    }
}

extension MatchingKeywordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MatchingKeywordCell {
            
            guard let selectedCell = cell.label.text else { return }
            if cell.isSelected {
                if let index = selectedKeywords.firstIndex(of: selectedCell) {
                    selectedKeywords.remove(at: index)
                    cell.setSelected(false, animated: true) // 셀의 선택 해제
                    cell.label.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor

                    matchingKeywordView.infoLabel.text = "보기를 선택해주세요."
                    matchingKeywordView.infoLabel.textColor = ColorGuide.main
                    print("~~ 인덱스 \(indexPath.item), \(selectedCell) 선택해제")

                } else {
                    selectedKeywords.append(selectedCell)
                    cell.label.layer.borderColor = ColorGuide.main.cgColor

                    matchingKeywordView.infoLabel.text = selectedCell
                    matchingKeywordView.infoLabel.textColor = .darkGray
                    print("~~ 인덱스 \(indexPath.item), \(selectedCell) 선택")
                    
                    let lastSelectedKeyword = selectedKeywords.last
                    print("~!!~!~!~마지막으로 선택된 키워드는 \(lastSelectedKeyword ?? "")")

                }
            }
//            cell.setView()
        }
    }
}
