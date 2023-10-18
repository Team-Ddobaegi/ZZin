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
        setMapView()
    }
    
   
    // MARK: - Settings
    
    private func setMapView() {
        searchView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
    
    // MARK: - Actions
    
    @objc private func mapButtonTapped() {
        print("mapButtonTapped")
        let mapViewController = SearchMapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    
}
