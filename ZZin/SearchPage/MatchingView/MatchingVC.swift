//
//  MatchingVC.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

class MatchingVC: UIViewController {
    
    
    //MARK: - Properties
    
    private let matchingView = MatchingView()
    
    var collectionView: UICollectionView!  // 테이블셀에 넣을 컬렉션뷰 선언
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMatchingView()
        setXMarkButton()
        setCostumCell()
        setTableViewAttribute()
        setMatchingViewConstraints()
    }
    
    
    // MARK: - Settings
    
    private func setMatchingView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(matchingView)
    }
    
    private func setTableViewAttribute(){
        // 매칭 업체 페이지 테이블뷰
        matchingView.setMatchingTableView.delegate = self
        matchingView.setMatchingTableView.dataSource = self
    }
    
    private func setCostumCell() {
        matchingView.setMatchingTableView.register(MatchingPlacePhotoCell.self, forCellReuseIdentifier: MatchingPlacePhotoCell.identifier)
        matchingView.setMatchingTableView.register(MatchingPlaceInfoCell.self, forCellReuseIdentifier: MatchingPlaceInfoCell.identifier)
        matchingView.setMatchingTableView.register(MatchingPlaceReviewCell.self, forCellReuseIdentifier: MatchingPlaceReviewCell.identifier)
    }
    
    // MARK: - configureUI
    
    func setMatchingViewConstraints(){
        matchingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Settings
    
    private func setXMarkButton(){
        matchingView.xMarkButton.addTarget(self, action: #selector(xMarkButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func xMarkButtonTapped(){
        print("서칭 페이지로 돌아갑니다.")
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - TableView

extension MatchingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 150
        case 1: return 420
        case 2: return 600
        default: return 700
        }
    }
     
    func numberOfSections(in tableView: UITableView) -> Int {3}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
           
        case 0:
            // 매칭 업체 포토 컬렉션뷰
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingPlacePhotoCell.identifier) as! MatchingPlacePhotoCell
            cell.selectionStyle = .none
            return cell
            
        case 1:
            // 매칭 업체의 정보
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingPlaceInfoCell.identifier, for: indexPath) as! MatchingPlaceInfoCell
            cell.selectionStyle = .none
            return cell
            
        case 2:
            // 매칭 업체를 추천하는 로컬주민들의 리뷰
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingPlaceReviewCell.identifier, for: indexPath) as! MatchingPlaceReviewCell
            cell.selectionStyle = .none
            return cell
            
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    
}

