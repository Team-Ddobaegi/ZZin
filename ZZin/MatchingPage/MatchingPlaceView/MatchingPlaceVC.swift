//
//  MatchingVC.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then
import Firebase

class MatchingPlaceVC: UIViewController {
    
    //MARK: - Properties
    
    private let matchingPlaceView = MatchingPlaceView()
    let dataManager = FireStoreManager()
    let db = Firestore.firestore()
    var placeID: String?
    var reviewID: [String?]?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }
    
    
    
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setXMarkButton()
        setTableViewAttribute() // 리뷰 들어갈 테이블뷰 셀 선언
        setCustomCell()
        configureUI()
    }
   
        
    private func setXMarkButton(){
        matchingPlaceView.xMarkButton.addTarget(self, action: #selector(xMarkButtonTapped), for: .touchUpInside)
    }
    
    private func setTableViewAttribute(){
        // 매칭 업체 페이지 테이블뷰
        matchingPlaceView.setMatchingPlaceTableView.delegate = self
        matchingPlaceView.setMatchingPlaceTableView.dataSource = self
        matchingPlaceView.setMatchingPlaceTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func setCustomCell() {
        matchingPlaceView.setMatchingPlaceTableView.register(MatchingPlacePhotoCell.self, forCellReuseIdentifier: MatchingPlacePhotoCell.identifier)
        matchingPlaceView.setMatchingPlaceTableView.register(MatchingPlaceInfoCell.self, forCellReuseIdentifier: MatchingPlaceInfoCell.identifier)
        matchingPlaceView.setMatchingPlaceTableView.register(MatchingPlaceReviewCell.self, forCellReuseIdentifier: MatchingPlaceReviewCell.identifier)
    }
    
    
    private func numberOfMatchingPlaceReviewCells() -> Int {
        // MatchingPlaceReviewCell의 개수 반환
        return 1
    }
    
    
    
    
    // MARK: - Actions
    
    @objc private func xMarkButtonTapped(){
        print("서칭 페이지로 돌아갑니다.")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - configureUI
    
    private func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews(){
        view.addSubview(matchingPlaceView)
    }
    
    private func setConstraints(){
        matchingPlaceView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}



//MARK: - 최상단 업체사진이 들어갈 CollectionView :: Layout

extension MatchingPlaceVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // 커스텀 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    // 커스텀 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewID?.count ?? 0
    }
    
    // 커스텀 셀 호출
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingPlacePhotoCollectionViewCell.identifier ,for: indexPath) as? MatchingPlacePhotoCollectionViewCell else {
            return UICollectionViewCell()
            }
        
        FireStoreManager.shared.fetchDataWithPid(pid: placeID ?? "") { (result) in
            switch result {
            case .success(let place):
               
                let placeImgPath = place.placeImg[indexPath.item]
                FireStorageManager().bindPlaceImgWithPath(path: placeImgPath, imageView: cell.placeImage)


            case .failure(let error):
                print("Error fetching review: \(error.localizedDescription)")
            }
        }
        return cell
    }
}



//MARK: - TableView

extension MatchingPlaceVC: UITableViewDataSource, UITableViewDelegate {
  

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 150
        case 1: return 420
        case 2:    
            // MatchingPlaceReviewCell 섹션의 높이 계산
            let numberOfReviewCells = numberOfMatchingPlaceReviewCells()
            let cellHeight: CGFloat = 230 // 미리 정의한 Cell의 높이
            
            return CGFloat(numberOfReviewCells) * cellHeight
        default: return 700
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {3}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return reviewID?.count ?? 0
        default: return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            // 매칭 업체 포토 컬렉션뷰
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingPlacePhotoCell.identifier) as! MatchingPlacePhotoCell
            cell.selectionStyle = .none
            cell.matchingPlacePhotoView.collectionView.delegate = self
            cell.matchingPlacePhotoView.collectionView.dataSource = self
            
            return cell
            
        case 1:
            // 매칭 업체의 정보
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchingPlaceInfoCell.identifier,for: indexPath) as? MatchingPlaceInfoCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            FireStoreManager.shared.fetchDataWithPid(pid: placeID ?? "") { (result) in
                switch result {
                case .success(let place):
                    let placeName = place.placeName
                    let placeAddress = place.address
                  
                    cell.placeTitleLabel.text = placeName
                    cell.placeAddresseLabel.text = placeAddress
                   
                case .failure(let error):
                    print("Error fetching review: \(error.localizedDescription)")
                }
            }
          
            
            return cell
            
        case 2:
            // 매칭 업체를 추천하는 로컬주민들의 리뷰
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchingPlaceReviewCell.identifier,for: indexPath) as? MatchingPlaceReviewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none

            FireStorageManager().bindViewOnStorageWithRid(rid: reviewID?[indexPath.row] ?? "", reviewImgView: cell.recommendPlaceReview.img, title: cell.recommendPlaceReview.reviewTitleLabel, companion: cell.recommendPlaceReview.withKeywordLabel, condition: cell.recommendPlaceReview.conditionKeywordLabel, town: cell.recommendPlaceReview.regionLabel)
           
            return cell
            
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("매칭 디테일 페이지로 이동합니다.")
        if tableView.cellForRow(at: indexPath) is MatchingPlaceReviewCell {
            let matchingPlaceReviewDetailVC = MatchingPlaceReviewDetailVC()
            matchingPlaceReviewDetailVC.reviewID = self.reviewID

            self.navigationController?.pushViewController(matchingPlaceReviewDetailVC, animated: true)
        }
    
    }
}

