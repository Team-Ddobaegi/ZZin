//
//  InfoViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit
import Then

class InfoViewController: UICollectionViewController {
    
       // MARK: - Properties
    let storageManager = FireStorageManager()
       private var profileView: UIView!
       private var customSegmentedControl: CustomSegmentedControl!
       // 현재 선택된 세그먼트 인덱스를 추적하는 변수를 추가합니다.
        var currentSegmentIndex: Int = 0
    let uid = "bo_bo_@kakao.com"
    var loadedRidAndPid: [String:[String]?] = [:]
    var pidArr: [String]? = []
    var ridArr: [String]? = []

       // MARK: - Initializers
       init() {
           let layout = UICollectionViewFlowLayout()
           super.init(collectionViewLayout: layout)
           layout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
           layout.minimumInteritemSpacing = 16
           layout.minimumLineSpacing = 20
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       // MARK: - Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
           print("viewdidload start")
           setupUI()
           
           DispatchQueue.main.async {[self] in
               storageManager.getPidAndRidWithUid(uid: uid){ [self] result in
                   loadedRidAndPid = result
                   print("loadedRidAndPid", loadedRidAndPid)
                   pidArr = loadedRidAndPid["pidArr"] ?? []
                   ridArr = loadedRidAndPid["ridArr"] ?? []
                   print("pidArr", pidArr)
                   print("ridArr", ridArr)
                   collectionView.reloadData()
               }
           }
       }

       // MARK: - UI Setup
       private func setupUI() {
           // Navigation Bar
           navigationItem.title = "마이페이지"
           navigationController?.navigationBar.prefersLargeTitles = true
           
           // delegate
           collectionView.delegate = self
           collectionView.dataSource = self

           // Collection View
           collectionView.backgroundColor = .systemBackground
           
           // cell register
           collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
           collectionView.register(RecommendedPlaceCell.self, forCellWithReuseIdentifier: RecommendedPlaceCell.identifier)
           collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
           collectionView.register(RewardCell.self, forCellWithReuseIdentifier: RewardCell.identifier)
           collectionView.register(SegmentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SegmentHeader.identifier)
           collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeaderView")
           collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DefaultSupplementaryView")
       }
}

// MARK: - UICollectionView DataSource & Delegate
extension InfoViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int{2}

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 1 else {return 1}
        switch currentSegmentIndex {
        case 0: return pidArr?.count ?? 1
        case 1: return ridArr?.count ?? 1
        case 2: return 8
        default: return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 1 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SegmentHeader", for: indexPath) as! SegmentHeader
                headerView.customSegmentedControl.onValueChanged = { [weak self] index in
                    self?.currentSegmentIndex = index
                    collectionView.reloadData()
                }
                return headerView
            } else {
                // 0번 섹션에는 헤더가 필요하지 않지만, dequeued view를 반환해야 합니다.
                let emptyHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmptyHeaderView", for: indexPath)
                return emptyHeaderView
            }
        default:
            // 기본 상황에서도 dequeued view를 반환합니다.
            let defaultView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DefaultSupplementaryView", for: indexPath)
            return defaultView
        }
    }


    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.section == 1 else {
            // 유저 프로필 정보 cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
            
            // TODO: cell에 필요한 데이터 전달 및 설정
            storageManager.bindProfileImgOnStorage(uid: uid, profileImgView: cell.profileImageView)
            
            return cell
        }
        switch currentSegmentIndex {
        case 0:
            // "맛집 추천"에 대한 셀 로드
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPlaceCell.identifier, for: indexPath) as! RecommendedPlaceCell
            
            let pid = pidArr?[indexPath.item] ?? ""
            storageManager.bindViewOnStorageWithPid(pid: pid, placeImgView: cell.customView.img, title: cell.customView.titleLabel, description: cell.customView.descriptionLabel)
            return cell
        case 1:
            // "리뷰"에 대한 셀 로드
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
            
            let rid = ridArr?[indexPath.item] ?? ""
            storageManager.bindViewOnStorageWithRid(rid: rid, reviewImgView: cell.customView.img, title: cell.customView.titleLabel, companion: cell.customView.companyLabel, condition: cell.customView.conditionLabel, town: cell.customView.regionLabel)
            
            return cell
        case 2:
            // "리워드"에 대한 셀 로드
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardCell.identifier, for: indexPath) as! RewardCell
            cell.imageView.image = UIImage(named: "medal_sample")
            cell.titleLabel.text = "💛우리동네 찐친"
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {return CGSize(width: collectionView.bounds.width, height: 50)}
        else {return CGSize(width: collectionView.bounds.width, height: 0)}
        
    }
    
}

extension InfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // 좌우 padding을 16씩 뺌
        guard indexPath.section == 1 else {
            return CGSize(width: width, height: 140)
        }
        switch currentSegmentIndex {
        case 0: // "맛집 추천"에 대한 셀 사이즈,
            return CGSize(width: (width - 16) / 2, height: (width - 16) / 2 * 228 / 170)
        case 1: // "리뷰"에 대한 셀 사이즈
            return CGSize(width: width, height: 230)
        case 2: // "리워드"에 대한 셀 사이즈
            let cellWidth = (width - 16) / 2
            return CGSize(width: cellWidth, height: cellWidth)
        default: return .zero
        }
    }
}
