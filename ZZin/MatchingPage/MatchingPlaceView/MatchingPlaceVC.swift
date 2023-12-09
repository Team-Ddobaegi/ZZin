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
import NMapsMap

class MatchingPlaceVC: UIViewController {
    
    //MARK: - Properties
    
    private let matchingPlaceView = MatchingPlaceView()
    var infoCell =  MatchingPlaceInfoCell()
    let db = Firestore.firestore()
    var placeID: String?
    var reviewID: [String?]?
    var placeNum: String?
    var isCallButtonSelected = false
    var isReviewButtonSelected = false
    var isLikeButtonSelected = false
    var companionKeywords : [String?]?
    var conditionKeywords : [String?]?
    var kindOfFoodKeywords : [String?]?
    var city : String?
    var town : String?
    var lat : Double?
    var lng : Double?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        fetchPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    func fetchPlaces(){
        FireStoreManager.shared.fetchDataWithPid(pid: placeID ?? "") { (result) in
            switch result {
            case .success(let place):
                let placeNum = place.placeTelNum
                
                self.placeNum = placeNum
                print("fetchPlaces : \(self.placeNum)")
                
            case .failure(let error):
                print("Error fetching review: \(error.localizedDescription)")
            }
        }
    }
    
    func makePlaceCall(placeNumber: String) {
        if let palceURL = URL(string: "tel://\(placeNumber)") {
            if UIApplication.shared.canOpenURL(palceURL) {
                UIApplication.shared.open(palceURL, options: [:], completionHandler: nil)
            } else {
                // 전화 걸기가 지원되지 않을 경우 사용자에게 메시지 표시
                let alert = UIAlertController(title: "실패", message: "이 기기에서는 전화를 지원하지 않습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func xMarkButtonTapped(){
        print("서칭 페이지로 돌아갑니다.")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func callButtonTapped(){
        print("\(self.placeNum)")
        print("전화하기 버튼 선택: \(!isCallButtonSelected)")
        isCallButtonSelected.toggle()
        
        let callAlert = UIAlertController(title: "전화 걸기", message: "전화번호: \(self.placeNum ?? "")", preferredStyle: .alert)
        let callAction = UIAlertAction(title: "전화걸기", style: .default) { [weak self] _ in
            self?.makePlaceCall(placeNumber: self?.placeNum ?? "")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        callAlert.addAction(callAction)
        callAlert.addAction(cancelAction)
        
        self.present(callAlert, animated: true, completion: nil)
    }
    
    
    @objc func reviewButtonTapped() {
        print("리뷰 버튼 선택: \(!isReviewButtonSelected)")
        print("리뷰 작성 페이지로 이동합니다")
        
        let postVC = PostViewController()
//        postVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(postVC, animated: true)
    }
    
    @objc func likeButtonTapped() {
//        print("가볼래요 버튼 선택: \(!isLikeButtonSelected)")
//        isLikeButtonSelected.toggle()
//        updateLikePlace()
        isPlaceMap = true
        if !isMapExist {
            let mapVC = SearchMapViewController()
//            mapVC.companionKeyword = self.companionKeywords
//            mapVC.conditionKeyword = self.conditionKeywords
//            mapVC.kindOfFoodKeyword = self.kindOfFoodKeywords
            mapVC.selectedCity = self.city
            mapVC.selectedTown = self.town
            mapVC.cameraLocation = NMGLatLng(lat: self.lat ?? 37.5666102, lng: self.lng ?? 126.9783881)
            navigationController?.pushViewController(mapVC, animated: true)
            print("지도로 가유~~~")
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    // MARK: - configureUI
    
    func updateButtonColor(button: UIButton, label: UILabel, isSelected: Bool) {
        if isSelected {
            button.tintColor = ColorGuide.main
            label.textColor = ColorGuide.main
        } else {
            button.tintColor = .darkGray
            label.textColor = .darkGray
        }
    }
    
    func updateLikePlace() {
        if isLikeButtonSelected {
            let alert = UIAlertController(title: "알림", message: "맛집이 저장되었습니다.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
            
        } else {
            let alert = UIAlertController(title: "알림", message: "맛집 저장이 취소되었습니다.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
        }
    }
    
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
    
    // 커스텀 셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
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
        case 1: return 200
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
            cell.matchingPlacePhotoView.collectionView.showsVerticalScrollIndicator = false
            
            return cell
            
        case 1:
            // 매칭 업체의 정보
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchingPlaceInfoCell.identifier,for: indexPath) as? MatchingPlaceInfoCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.placeCallButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
            cell.placeReviewButton.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
            cell.placeMapButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
            
//            cell.colorChange  = { [self] in
//                updateButtonColor(button: cell.placeLikeButton, label: cell.placeLikeLabel, isSelected: isLikeButtonSelected)
//            }
            
            
            FireStoreManager.shared.fetchDataWithPid(pid: placeID ?? "") { (result) in
                switch result {
                case .success(let place):
                    let placeName = place.placeName
                    let placeAddress = place.address
                    self.companionKeywords = [place.companion]
                    self.conditionKeywords = [place.condition]
                    self.kindOfFoodKeywords = [place.kindOfFood]
                    self.lat = place.lat
                    self.lng = place.long
                    self.city = place.city
                    self.town = place.town
                    
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
        //        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath) is MatchingPlaceReviewCell {
            print("매칭 디테일 페이지로 이동합니다.")
            
            let matchingPlaceReviewDetailVC = MatchingPlaceReviewDetailVC()
            matchingPlaceReviewDetailVC.reviewID = reviewID?[indexPath.row]
            
            self.navigationController?.pushViewController(matchingPlaceReviewDetailVC, animated: true)
        }
        
    }
}

