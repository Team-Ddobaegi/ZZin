//
//  MainViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import FirebaseAuth
import NMapsGeometry.NMGLatLng

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = MainView()
    let storageManager = FireStorageManager()
    let dataManager = FireStoreManager()
    var placeData: [Place] = []
    var reviewData: [Review] = []
    var sectionHeaderHeight: CGFloat = 35
    // current user로 변경될 수 있도록 로그인에서 수정 🚨
    let uid = Auth.auth().currentUser?.uid
    
    // MARK: - Settings
    
    func setTableViewAttribute() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.showsVerticalScrollIndicator = false
    }
    
    func fetchReviewData() {
        dataManager.getReviewData { result in
            switch result {
            case .success(let review):
                print("======= 이게 데이터다 ========",review)
                self.reviewData = review
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print("=========== 에러가 발생했습니다. - \(error.localizedDescription) =========== ")
            }
        }
    }
    
    func fetchPlaceData() {
        dataManager.getPlaceData { result in
            switch result {
            case .success(let place):
                print("======= 이게 데이터다 ========",place)
                self.placeData = place
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print("=========== 에러가 발생했습니다. - \(error.localizedDescription) =========== ")
            }
        }
    }
    
    // MARK: - Configure UI
    func setUI() {
        view.backgroundColor = .customBackground
        view.addSubview(mainView)
        mainView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Life Cycles
extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReviewData()
        fetchPlaceData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewAttribute()
        setUI()
        LocationService.shared.startUpdatingLocation()
    }
}

//MARK: - 테이블뷰 셀
extension MainViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return sectionHeaderHeight
        case 1: return sectionHeaderHeight
        default: return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 영역별 높이 다르게 설정
        switch indexPath.section {
        case 0: return 100
        case 1: return 250
        default: return 200
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 섹션 헤더가 화면 위로 스크롤되지 않도록 고정
        if scrollView.contentOffset.y < sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func reportingButtonTapped() {
        print("신고하기 버튼이 눌렸습니다.")
        
        let alert = UIAlertController(title: "게시물 신고", message: "해당 게시물을 신고하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) { action in
            print("해당 게시물이 신고되었습니다.")
        }
        
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return reviewData.count
        default: return 1
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: LocalTableViewCell.identifier, for: indexPath) as! LocalTableViewCell
            cell.delegate = self
            cell.recieveData(full: placeData)
            cell.localCollectionView.reloadData()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableviewCell.identifier, for: indexPath) as! ReviewTableviewCell
            
            if !reviewData.isEmpty {
                let data = reviewData[indexPath.row]
                storageManager.bindViewOnStorageWithRid(rid: data.rid, reviewImgView: cell.placeReview.img, title: cell.placeReview.reviewTitleLabel, companion: cell.placeReview.withKeywordLabel, condition: cell.placeReview.conditionKeywordLabel, town: cell.placeReview.regionLabel)
                }
            cell.placeReview.regionLabel.isHidden = true
            cell.placeReview.underline.isHidden = true
            cell.reportingButton.addTarget(self, action: #selector(reportingButtonTapped), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableviewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainHeaderView.identifier) as? MainHeaderView
        tableviewHeaderView?.configure(with: section)
        return tableviewHeaderView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("##### 셀 터치가 됐읍니두 didselectIteamAt")
        didSelectReview(at: indexPath)
    }
}

extension MainViewController: ReviewTableViewCellDelegate {
    func didSelectReview(at indexPath: IndexPath) {
        print("###리뷰셀 터치")
        let matchingPlaceVC = MatchingPlaceVC()
        matchingPlaceVC.placeID = placeData[indexPath.item].pid
        matchingPlaceVC.reviewID = placeData[indexPath.item].rid
        self.navigationController?.pushViewController(matchingPlaceVC, animated: true)
    }
}

extension MainViewController: LocalTableViewCellDelegate {
    func didSelectPlace(at indexPath: IndexPath) {
        isPlaceMap = true
        let mapVC = SearchMapViewController()
        mapVC.selectedCity = placeData[indexPath.item].city
        let town = placeData[indexPath.item].town
        mapVC.selectedTown = town
        let selectedTownEnum = SeoulDistrictOfficeCoordinates.find(for: town)
        let coords = selectedTownEnum?.coordinate
        let officeCoords = NMGLatLng(lat: coords?.latitude ?? 37.5666102, lng: coords?.longitude ?? 126.9783881)
        mapVC.cameraLocation = officeCoords
        navigationController?.pushViewController(mapVC, animated: true)
        print("지도로 가유~~~")
    }
}
