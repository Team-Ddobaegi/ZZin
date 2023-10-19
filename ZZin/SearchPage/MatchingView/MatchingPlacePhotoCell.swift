//
//  MatchingRestaurantPhotoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

class MatchingPlacePhotoCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    //
    // MARK: - Properties
    
    static let identifier = "MatchingRestaurantPhotoCell"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MatchingPlacePhotoCell.self, forCellWithReuseIdentifier: MatchingPlacePhotoCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cv.backgroundColor = .white
        
        return cv
    }()
    
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddsubView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let imageview = UIView().then {
        $0.backgroundColor = ColorGuide.main
    }
    
    
    //MARK: - Settings
    
    private func setAddsubView() {
        addSubview(imageview)
//        imageView?.addSubview(collectionView)
    }
    
    
    //MARK: - ConfigureUI
    
    private func setConstraints(){
        imageview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
    //MARK: - CollectionView Layout
    
    // 커스텀 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    // 커스텀 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {3}
    
    // 커스텀 셀 호출
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier ,for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}

