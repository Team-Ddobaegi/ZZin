//
//  MatchingVC.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/19/23.
//

import UIKit
import SnapKit
import Then

class MatchingVC: UITableViewController {
    
    
    //MARK: - Properties
    
    private let matchingView = MatchingView()
    
  
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMatchingView()
        setXMarkButton()
    }
    
    
    // MARK: - Settings
    private func setMatchingView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        matchingView.isUserInteractionEnabled = true

        view.addSubview(matchingView)
    }
    
    
    // MARK: - Settings
    
    private func setXMarkButton(){
        matchingView.xMarkButton.addTarget(self, action: #selector(xMarkButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func xMarkButtonTapped() {
        print("서칭 페이지로 돌아갑니다.")
        self.navigationController?.popViewController(animated: true)
    }
}
