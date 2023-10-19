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
        rankButtonAction()
        
        
    }
}

    private extension MainViewController {
        func setupUI() {
            view = mainView
            mainView.recommendcollectionView.dataSource = self
            mainView.recommendcollectionView.delegate = self
            mainView.reviewCollectionView.dataSource = self
            mainView.reviewCollectionView.delegate = self
            
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
        
        @objc func rankButtonAction() {
            mainView.rank1Button.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.rank2Button.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.rank3Button.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.rank4Button.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.rank5Button.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.rank6Button.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)

        }
        
        @objc func searchButtonTapped() {
            navigationController?.pushViewController(SearchViewController(), animated: true)
        }
    }
 
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.recommendcollectionView {
            
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPageRecommendCollectionViewCell.identifier, for: indexPath) as? MainPageRecommendCollectionViewCell else {
                fatalError()
            }
            
            return cell
        } else if collectionView == mainView.reviewCollectionView {
               guard let secondCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPageReviewCollectionViewCell.identifier, for: indexPath) as? MainPageReviewCollectionViewCell else {
                    fatalError()
                }
                
            secondCell.layer.borderWidth = 1.0
            secondCell.layer.cornerRadius = 25
            secondCell.layer.masksToBounds = true
                return secondCell
            }
        return UICollectionViewCell()
        }
    }
    
    extension MainViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainView.recommendcollectionView {
                return CGSize(width: 76, height: 110)
            } else if collectionView == mainView.reviewCollectionView {
                return CGSize(width: 353, height: 237)
            }
            return CGSize(width: 50, height: 50)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            if collectionView == mainView.recommendcollectionView {
                return 25
            } else if collectionView == mainView.reviewCollectionView {
                return 25
            }
            return 25
        }
    }

