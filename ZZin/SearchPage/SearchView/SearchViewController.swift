//
//  SearchViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubView()
        setMapView()
        setLocationPickerView()
        configureUI()
    }
    
   
    // MARK: - Settings
    
    private func setAddSubView(){
        view.backgroundColor = .white
        view.addSubview(searchView)
        view.addSubview(collectionView)
    }
    
    private func setMapView(){
        searchView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    private func setLocationPickerView(){
        searchView.setLocationButton.addTarget(self, action: #selector(setLocationButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
    private let collectionView = SearchResultCollectionView()

    
    // MARK: - Actions
    
    @objc private func mapButtonTapped() {
        print("mapButtonTapped")
        let mapViewController = SearchMapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @objc private func setLocationButtonTapped() {
        print("setLocationButtonTapped")
        let locationSettingVC = LocationSettingVC()
        navigationController?.present(locationSettingVC, animated: true)
    }
    
    //MARK: - Configure UI
    
    func configureUI(){
        setSearchViewConstraints()
        setCollectionViewConstraints()
    }
    
    func setSearchViewConstraints(){
        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(232)

        }
    }
    
    func setCollectionViewConstraints(){
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-90)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
