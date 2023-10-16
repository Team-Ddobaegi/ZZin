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
    }
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
}
