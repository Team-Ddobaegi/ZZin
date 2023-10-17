//
//  MainViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - varibles
    
    private let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        
    }
}

    private extension MainViewController {
        func setupUI() {
            view = mainView
            mainView.recommendcollectionView.dataSource = self
            mainView.recommendcollectionView.dataSource = self
            mainView.collectionView.dataSource = self
            mainView.collectionView.delegate = self
            mainView.reviewcollectionView.dataSource = self
            mainView.reviewcollectionView.delegate = self
            
            if let settingImage = UIImage(named: "search") {
                let originalSize = settingImage.size
                let scaledSize = CGSize(width: originalSize.width * 0.8, height: originalSize.height * 0.8)
                let renderer = UIGraphicsImageRenderer(size: scaledSize)
                let scaledSettingImage = renderer.image { _ in
                    settingImage.draw(in: CGRect(origin: .zero, size: scaledSize))
                }
                let coloredSettingImage = scaledSettingImage.withTintColor(.black, renderingMode: .alwaysOriginal)
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: coloredSettingImage, style: .plain, target: self, action: #selector(searchButtonTapped))
            }
        }
        
        @objc func searchButtonTapped() {
            navigationController?.pushViewController(SearchViewController(), animated: true)
        }
    }
 
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPageRecommendCollectionViewCell.identifier, for: indexPath) as? MainPageRecommendCollectionViewCell else {
            fatalError()
        }
                
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 38
        cell.layer.masksToBounds = true
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = (view.bounds.size.width - 76) / 2
        return CGSize(width: 76, height: 76)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

