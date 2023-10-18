//
//  SearchViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func loadView() {
        view = searchView
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 임시 내비게이션 바 버튼 설정
        let mapButton = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonTapped))
        navigationItem.rightBarButtonItem = mapButton
        //        searchView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        //        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func mapButtonTapped() {
        print("mapButtonTapped")
        let mapViewController = SearchMapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
}
