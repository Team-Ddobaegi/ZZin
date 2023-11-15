//
//  TableViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/02.
//

import UIKit


class LocalTableViewCell: UITableViewCell {
    static let identifier = "LocalTableViewCell"
    private let storageManager = FireStorageManager()
    private var placeData: [Place] = []
    private var pidData: String = ""
    
    lazy var localCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(LocalCollectionViewCell.self, forCellWithReuseIdentifier: LocalCollectionViewCell.identifier)
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
        contentView.addSubview(localCollectionView)
        localCollectionView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().inset(15)
        }
    }
    
    func setDelegate() {
        localCollectionView.delegate = self
        localCollectionView.dataSource = self
    }
    
    func recieveData(full: [Place]) {
        self.placeData = full
        print("========= 지역 데이터가 잘 넘어왔어요. ==========", placeData)
    }
}

extension LocalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalCollectionViewCell.identifier, for: indexPath) as? LocalCollectionViewCell else { return UICollectionViewCell() }
        
        if !placeData.isEmpty {
            let data = placeData[indexPath.row]
            let pidData = data.pid
            print(data.town)
            print(data.placeImg)
            
            storageManager.bindViewOnStorageWithPid(pid: pidData, placeImgView: cell.recommendPictureView, title: nil, dotLabel: nil, placeTownLabel: cell.recommendLabel, placeMenuLabel: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 77, height: 98)
    }
}
