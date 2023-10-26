//
//  MatchingReviewDetailVC.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit

class MatchingPlaceDetailVC: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setCostumCell()
        setTableViewAttribute()
        configureUI()
    }
    
    private func setCostumCell() {
        // 커스텀 셀 선언
        matchingPlaceDetailView.setMatchingPlaceReviewTableView.register(MatchingThumbnailCell.self, forCellReuseIdentifier: MatchingThumbnailCell.identifier)
        matchingPlaceDetailView.setMatchingPlaceReviewTableView.register(MatchingReviewPhotoCell.self, forCellReuseIdentifier: MatchingReviewPhotoCell.identifier)
        matchingPlaceDetailView.setMatchingPlaceReviewTableView.register(MatchingReviewTextCell.self, forCellReuseIdentifier: MatchingReviewTextCell.identifier)
    }
    
    private func setTableViewAttribute(){
        // 매칭 업체 페이지 테이블뷰
        matchingPlaceDetailView.setMatchingPlaceReviewTableView.delegate = self
        matchingPlaceDetailView.setMatchingPlaceReviewTableView.dataSource = self
    }
    
    
    //MARK: - Properties
    
    private let matchingPlaceDetailView = MatchingPlaceDetailView()
    
    let reviewText = MatchingReviewTextCell().reviewTextLabel.text

    
    // MARK: - Actions
    
    @objc private func xMarkButtonTapped(){
        print("매칭 업체 페이지로 돌아갑니다.")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - configureUI
    
    func configureUI(){
        view.addSubview(matchingPlaceDetailView)
        
        matchingPlaceDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}



// MARK: - TableView
extension MatchingPlaceDetailVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return MatchingThumbnailCell.cellHeight()
        case 1:
            return MatchingReviewPhotoCell.cellHeight()
        case 2:
            let text = "\(reviewText ?? "")"
            return MatchingReviewTextCell.calculateHeight(for: text)

        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {3}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            // 매칭 리뷰 썸네일
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingThumbnailCell.identifier) as! MatchingThumbnailCell
            cell.selectionStyle = .none
            cell.xMarkButton.addTarget(self, action: #selector(xMarkButtonTapped), for: .touchUpInside)
            
            return cell
            
        case 1:
            // 매칭 리뷰 사진
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingReviewPhotoCell.identifier, for: indexPath) as! MatchingReviewPhotoCell
            cell.selectionStyle = .none
          
            return cell
            
        case 2:
            // 매칭 리뷰 컨텐츠
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingReviewTextCell.identifier, for: indexPath) as! MatchingReviewTextCell
            cell.selectionStyle = .none
          
            let text = "\(reviewText ?? "")"
            cell.setReviewText(text)
            
            return cell
        
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
}
