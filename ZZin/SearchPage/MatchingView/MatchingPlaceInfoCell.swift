//
//  MatchingRestaurantInfoCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

class MatchingPlaceInfoCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddsubView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    static let identifier = "MatchingRestaurantInfoCell"
    
    private let matchingView = MatchingView()
    
    public let view = UIView().then {
        $0.backgroundColor = .black
    }
    
    // 매칭 맛집 사진이 보여지는 컬렉션뷰입니두
    lazy var matchingRestaurantPhoto: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .red
        cv.register(MatchingRestaurantPhotoCell.self, forCellWithReuseIdentifier: MatchingRestaurantPhotoCell.identifier)
        
        return cv
    }()
    
    //MARK: - Settings
    
    private func setAddsubView() {
        addSubview(view)
        addSubview(matchingRestaurantPhoto)

    }
    
    
    //MARK: - ConfigureUI
    private func setConstraints(){
        // 업체 정보를 보여줄 뷰
        view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(150)
        }
    }
    private func collectionViewConstraints() {
        // 매칭 업체 사진 컬렉션뷰
        matchingRestaurantPhoto.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
//            $0.top.equalTo(setMatchingTableView.snp.top).offset(200)
            $0.height.equalTo(150)
        }
    }
    
    
    
    
    
}
