//
//  TableViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/02.
//

import UIKit

class LocalTableViewCell: UITableViewCell {
    weak var delegate: LocalTableViewCellDelegate?
    static let identifier = "LocalTableViewCell"
    private let storageManager = FireStorageManager()
    private var placeData: [Place] = []
    private var pidData: String = ""
    private var filteredData: Set<String> = []
    
    lazy var localCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(LocalCollectionViewCell.self, forCellWithReuseIdentifier: LocalCollectionViewCell.identifier)
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
        print(">> 지역 구분")
    }
    
    func groupData() {
        let towns = placeData.map { $0.town }
        print(towns)
        
        for town in towns {
            if !filteredData.contains(town) {
                filteredData.insert(town)
                print("이건 개개인",town)
            }
        }
    }
}

extension LocalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // grouping만 반환
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalCollectionViewCell.identifier, for: indexPath) as? LocalCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if !filteredData.isEmpty {
            let uniqueTowns = Array(filteredData)
            let townData = placeData.filter { $0.town == uniqueTowns[indexPath.row] }
            
            if let data = townData.first {
                let pidData = data.pid
                storageManager.bindViewOnStorageWithPid(pid: pidData, placeImgView: cell.recommendPictureView, title: nil, dotLabel: nil, placeTownLabel: cell.recommendLabel, placeMenuLabel: nil)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 77, height: 98)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectPlace(at: indexPath)
    }
}

protocol LocalTableViewCellDelegate: AnyObject {
    func didSelectPlace(at indexPath: IndexPath)
}

