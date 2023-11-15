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
    private var reviewData: [Review] = []
    private var reviewID: [String] = []
    
    lazy var reviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 280)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        collectionView.backgroundColor = .customBackground
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
        backgroundColor = .customBackground
        contentView.addSubview(reviewCollectionView)
        reviewCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setDelegate() {
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
    }
    
    func recieveData(data: [Review]) {
        self.reviewData = data
        print("데이터를 받았습니다.", reviewData)
    }
}

extension ReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        if !reviewData.isEmpty {
            let data = reviewData[indexPath.row]
            storageManager.bindViewOnStorageWithRid(rid: data.rid, reviewImgView: cell.reviewUiView.img, title: cell.reviewUiView.reviewTitleLabel, companion: cell.reviewUiView.withKeywordLabel, condition: cell.reviewUiView.conditionKeywordLabel, town: cell.reviewUiView.regionLabel)
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath) 셀이 눌렸습니다.")
        
        if collectionView.cellForItem(at: indexPath) is MatchingResultCell {
            print("매칭 업체 페이지로 이동합니다.")
//            self.navigationController?.pushViewController(matchingPlaceVC, animated: true)
//            matchingPlaceVC.placeID = place?[indexPath.item].pid
//            matchingPlaceVC.reviewID = place?[indexPath.item].rid
        }
    }
}
