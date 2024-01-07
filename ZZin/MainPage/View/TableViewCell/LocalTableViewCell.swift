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
    private var filteredData: Dictionary<String, [Place]> = [:]
    
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
        print("========= 지역을 나누었어요 ========", placeData)
    }
    
    func groupData() {
        // 지역명 순으로 데이터 정렬? / filter? / sorting? - 대량의 데이터 중 알맞는 텍스트끼리 묶어야 하는 상황이니까 grouping이 맞는 방법 아닐까. > 배열에 grouping이 존재하는지 확인, 별도로 없을 경우 dictionary로 key를 구분하는 방법 고려
        
        // 배열에 담긴 값을 특정 sequence로 정렬 > grouping 완료
        self.filteredData = Dictionary(grouping: self.placeData, by: {$0.town})
        print("========== 지역이 출력:", filteredData)
    }
}

extension LocalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 전체 데이터에서 grouping된 갯수만 반환
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalCollectionViewCell.identifier, for: indexPath) as? LocalCollectionViewCell else {
            return UICollectionViewCell()
        }
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectPlace(at: indexPath)
    }
}

protocol LocalTableViewCellDelegate: AnyObject {
    func didSelectPlace(at indexPath: IndexPath)
}

