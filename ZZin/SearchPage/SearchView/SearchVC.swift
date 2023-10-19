//
//  SearchViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit
import Then

class SearchVC: UIViewController {
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setMapView()
        setLocationPickerView()
        configureUI()
        setCollectionViewAttribute()
        setKeywordView()
    }
    
    
    // MARK: - Settings
    
    private func setView(){
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
    
    private func setCollectionViewAttribute(){
        collectionView.collectionView.delegate = self
        collectionView.collectionView.dataSource = self
    }
    
    private func setKeywordView(){
        searchView.firstKeywordButton.addTarget(self, action: #selector(keywordButtonTapped), for: .touchUpInside)
        searchView.secondKeywordButton.addTarget(self, action: #selector(keywordButtonTapped), for: .touchUpInside)
        searchView.menuKeywordButton.addTarget(self, action: #selector(keywordButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
    private let collectionView = SearchResultCollectionView()
    
    private var recommendItems = [RecommendList]()
    
    
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
    
    @objc private func keywordButtonTapped() {
        print("keywordButtonTapped")
        let keywordView = KeywordPage()
        navigationController?.present(keywordView, animated: true)
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


extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 25, height: collectionView.frame.width / 2 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //                return recommendItems.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier ,for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 양 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("매칭 업체 페이지로 이동합니다.")
        if collectionView.cellForItem(at: indexPath) is SearchResultCell {
            
            let matchingVC = MatchingVC()
//            let nav = UINavigationController(rootViewController: matchingVC)
//            nav.modalPresentationStyle = .currentContext
//            self.present(nav, animated: true)
                        self.navigationController?.pushViewController(matchingVC, animated: true)
        }
    }
}



