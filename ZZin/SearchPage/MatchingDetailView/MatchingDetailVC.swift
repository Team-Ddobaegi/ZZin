//
//  MatchingReviewDetailVC.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit

class MatchingDetailVC: UIViewController {
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setXMarkButton()
        
    }
    
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(matchingDetailView)
        setMatchingDetailViewConstraints()
    }
    
    
    //MARK: - Properties
    
    private let matchingDetailView = MatchingDetailView()
    
    private func setXMarkButton(){
        matchingDetailView.xMarkButton.addTarget(self, action: #selector(xMarkButtonTapped), for: .touchUpInside)
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
