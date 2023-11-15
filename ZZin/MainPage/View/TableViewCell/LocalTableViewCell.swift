//
//  TableViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/02.
//

import UIKit

class LocalTableViewCell: UITableViewCell {
    static let identifier = "LocalTableViewCell"
    
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
}

extension LocalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalCollectionViewCell.identifier, for: indexPath) as! LocalCollectionViewCell
        cell.setComponents(text: "변경", image: "person.fill")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 77, height: 98)
    }
}
