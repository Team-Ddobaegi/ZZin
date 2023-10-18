//
//  SearchResult.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/17/23.
//

import UIKit
import SnapKit
import Then

class SearchResultCV: UIViewController {
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        configureUI()
    }
    
    
    //MARK: - Properties
    
    private let reuseIdentifier = "Cell"
    
    private var recommendItems: [RecommendList] = []
    
    private let collectionView: UICollectionView = {
        // UICollectionView 정의
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    //MARK: - Settings
    
    private func setCollectionView(){
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBlue
        
        // 커스텀 셀 등록
//        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        view.addSubview(collectionView)
    }
    
    //MARK: - Configure UI
    
    private func configureUI(){
        collectionView.snp.makeConstraints {
            $0.top.equalTo(200)
            $0.leading.trailing.equalToSuperview().offset(20)
        }
    }
}



//extension SearchResultCV: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return recommendItems.count
//        return 1
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
//        let item = recommendItems[indexPath.item]
//        cell.configure(with: item) // 커스텀 메서드를 사용하여 데이터 설정
//        return cell
//    }
    
    
//}

