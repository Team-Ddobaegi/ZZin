//
//  SearchResultView.swift
//  Pods
//
//  Created by t2023-m0045 on 10/18/23.
//

import UIKit

class SearchResultCollectionView: UIView {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Properties
    private let searchView = SearchView()
    
    private let reuseIdentifier = "Cell"
    
    private var recommendItems: [RecommendList] = []
    
    
    lazy var searchResultView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .green
        cv.delegate = self
        cv.dataSource = self
        cv.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        
        return cv
    }()
    
    //MARK: - Helpers
    
    
//    addSubview(searchResultView)
    
    func setCollectionViewConstraints(){
        searchResultView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(-90)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

//MARK: - CollectionView

extension SearchResultCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier ,for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 2, height: collectionView.frame.width / 3 - 2)
    }
    
    // 세로 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 2
    }

    // 가로 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 2
    }
}
