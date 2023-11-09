//
//  InfoViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit
import Then
import FirebaseFirestore

class InfoViewController: UICollectionViewController {
    
    // MARK: - Properties
    let storageManager = FireStorageManager()
    let storeManager = FireStoreManager.shared
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
        setupNavBar()
        
        DispatchQueue.main.async {[self] in
            storageManager.getPidAndRidWithUid(uid: uid){ [self] result in
                loadedRidAndPid = result
                pidArr = loadedRidAndPid["pidArr"] ?? []
                ridArr = loadedRidAndPid["ridArr"] ?? []
                collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        // Navigation Bar
        navigationItem.title = "마이페이지"
        
        // delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Collection View
        collectionView.backgroundColor = .systemBackground
        
        // cell register
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        collectionView.register(RecommendedPlaceCell.self, forCellWithReuseIdentifier: RecommendedPlaceCell.identifier)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.register(SegmentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SegmentHeader.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeaderView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DefaultSupplementaryView")
    }
    
    
    func setupNavBar() {
        var rightButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(rightButtonTapped))
        rightButton.tintColor = .label
        self.navigationItem.rightBarButtonItems = [rightButton]
        
        var leftButton = UIBarButtonItem(image: UIImage(systemName: "heart.circle.fill"), style: .plain, target: self, action: #selector(leftButtonTapped))
        leftButton.tintColor = .label
        self.navigationItem.leftBarButtonItems = [leftButton]
        
        
    }
    @objc func rightButtonTapped() {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    @objc func leftButtonTapped() {
        let zzimVC = ZzimTableViewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(zzimVC, animated: false)
        
        //        self.navigationController?.pushViewController(zzimVC, animated: true)
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
            cell.editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
            // TODO: cell에 필요한 데이터 전달 및 설정
            storageManager.bindProfileImgOnStorage(uid: uid, profileImgView: cell.profileImageView)
            
            return cell
        }
        switch currentSegmentIndex {
        case 0:
            // "맛집 추천"에 대한 셀 로드
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPlaceCell.identifier, for: indexPath) as! RecommendedPlaceCell
            let view = cell.customView
            let pid = pidArr?[indexPath.item] ?? ""
            
            storageManager.bindViewOnStorageWithPid(pid: pid, placeImgView: view.img, title: view.titleLabel, dotLabel: view.dotLabel, placeTownLabel: view.placeTownLabel, placeMenuLabel: view.placeMenuLabel)
            return cell
        case 1:
            // "리뷰"에 대한 셀 로드
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
            
            let rid = ridArr?[indexPath.item] ?? ""
            storageManager.bindViewOnStorageWithRid(rid: rid, reviewImgView: cell.customView.img, title: cell.customView.reviewTitleLabel, companion: cell.customView.withKeywordLabel, condition: cell.customView.conditionKeywordLabel, town: cell.customView.regionLabel)
            
            cell.trashButton.tag = indexPath.item
            cell.editButton.tag = indexPath.item
            
            cell.trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {return CGSize(width: collectionView.bounds.width, height: 50)}
        else {return CGSize(width: collectionView.bounds.width, height: 0)}
        
    }
    
    
    @objc func editButtonTapped(index: Int) {
        print("탭탭 수정수정", index)
    }
    @objc func trashButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let popup = UIAlertController(title: "리뷰 삭제", message: "정말로 리뷰를 삭제하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let confirmDelete = UIAlertAction(title: "삭제", style: .destructive) { [self] _ in
            // 클릭 시 처리할 내용 (boardInfo 삭제)
            guard let rid = ridArr?[index] as? String else {return}
            
            DispatchQueue.main.async{ [self] in
                storeManager.deleteReview(rid: rid)
                self.ridArr?.remove(at: index)
                self.collectionView.reloadData()
            }
        }
        popup.addAction(cancel)
        popup.addAction(confirmDelete)
        self.present(popup, animated: true)
    }
    
    @objc func editProfileButtonTapped() {
        print("탭미탭미")
        let editVC = EditProfileViewController()
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.pushViewController(editVC, animated: true)
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
        default: return .zero
        }
    }
}
