//
//  SearchViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.setTitle("Map", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func mapButtonTapped() {
        let mapVC = SearchMapViewController()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(mapButton)
        
        mapButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalToSuperview().offset(100)
        }
    }
}
