//
//  MatchingReviewDetailVC.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit

class MatchingDetailVC: UIViewController {
    
    
    //MARK: - Properties
    
    private let matchingDetailView = MatchingDetailView()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(matchingDetailView)
        
        setTableViewAttribute()
        setCostumCell()         // 테이블뷰 셀 선언
        setMatchingDetailViewConstraints()
    }
    
    private func setTableViewAttribute(){
        // 매칭 업체 페이지 테이블뷰
        matchingDetailView.setMatchingDetailTableView.delegate = self
        matchingDetailView.setMatchingDetailTableView.dataSource = self
    }
    
    private func setCostumCell() {
        matchingDetailView.setMatchingDetailTableView.register(MatchingThumbnailCell.self, forCellReuseIdentifier: MatchingThumbnailCell.identifier)
        matchingDetailView.setMatchingDetailTableView.register(MatchingContentsCell.self, forCellReuseIdentifier: MatchingContentsCell.identifier)

    }
    
    
    // MARK: - Actions
    
    @objc private func xMarkButtonTapped(){
        print("매칭 업체 페이지로 돌아갑니다.")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - configureUI
    
    func setMatchingDetailViewConstraints(){
        matchingDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

extension MatchingDetailVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 240
        case 1: return 300
        default: return 700
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {2}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            // 매칭 리뷰 썸네일
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingThumbnailCell.identifier) as! MatchingThumbnailCell
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            // 매칭 리뷰 컨텐츠
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingContentsCell.identifier, for: indexPath) as! MatchingContentsCell
            cell.selectionStyle = .none
          
            return cell
        
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
}
