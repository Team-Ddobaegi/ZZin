//
//  ReviewTableViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/03.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    static let identifier = "ReviewTableViewCell"
    
    private let storageManager = FireStorageManager()
    var data: [String]? = []
    
    private lazy var reviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 230)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(reviewCollectionView)
        reviewCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setDelegate() {
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
    }
    
    func dataBinding(data: [String]?) {
        self.data = data
        print("데이터가 넘어 왔습니다. - \(data)")
    }
}

extension ReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell else { fatalError() }
        if data != [] {
            if let rid = data?[indexPath.item] {
                cell.dataBinding(rid: rid)
            }
        }
        return cell
    }
}
