//
//  MainViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - varibles
    
    let storageManager = FireStorageManager()
    private let mainView = MainView()
    private let scrollView = UIScrollView()
    
    var reviewData: [Review] = []
    var placeData: [Place] = []
    var loadedRidAndPid: [String:[String]?] = [:]
    var pidArr: [String]? = []
    var ridArr: [String]? = []
    let uid = "bo_bo_@kakao.com"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        rankButtonAction()
        fetchdata()
        placsFetchdata()
        setupUI()
        
        DispatchQueue.main.async {[self] in
            storageManager.getPidAndRidWithUid(uid: uid){ [self] result in
                loadedRidAndPid = result
                print("loadedRidAndPid", loadedRidAndPid)
                pidArr = loadedRidAndPid["pidArr"] ?? []
                ridArr = loadedRidAndPid["ridArr"] ?? []
                print("pidArr", pidArr)
                print("ridArr", ridArr)
                self.mainView.reviewCollectionView.reloadData()
                self.mainView.recommendCollectionView.reloadData()
            }
        }        
    }
    
    func fetchdata() {
        FireStoreManager.shared.getReviewData { data in
            switch data {
            case.success(let result):
                self.reviewData = result
                
                self.mainView.reviewCollectionView.reloadData()
                self.mainView.recommendCollectionView.reloadData()
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func placsFetchdata() {
        FireStoreManager.shared.getPlaceData { data in
            switch data {
            case.success(let result):
                self.placeData = result
                
                self.mainView.reviewCollectionView.reloadData()
                self.mainView.recommendCollectionView.reloadData()

            case.failure(let error):
                print(error)
                
            }
        }
    }
}
    private extension MainViewController {
        func setupUI() {
            view.addSubview(scrollView)
            scrollView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            scrollView.addSubview(mainView)
            mainView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(scrollView)
            }
            
            mainView.recommendCollectionView.dataSource = self
            mainView.recommendCollectionView.delegate = self
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
            mainView.topRankButton.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.secondRankButton.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.thirdRankButton.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.fourthRankButton.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.fifthRankButton.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            mainView.sixthRankButton.addTarget(self, action: #selector(rankButtonAction), for: .touchUpInside)
            
            mainView.topRankButton.tag = 1
            mainView.secondRankButton.tag = 2
            mainView.thirdRankButton.tag = 3
            mainView.fourthRankButton.tag = 4
            mainView.fifthRankButton.tag = 5
            mainView.sixthRankButton.tag = 6

        }
        
        @objc func rankButtonTapped(_ sender: UIButton) {
            var rank1Button: String = ""

            
            switch sender.tag {
            case 1:
                rank1Button = "1"
            case 2:
                rank1Button = "2"
            case 3:
                rank1Button = "3"
            case 4:
                rank1Button = "4"
            case 5:
                rank1Button = "5"
            case 6:
                rank1Button = "6"
            default:
                break
            }
    }

        
        @objc func searchButtonTapped() {
            navigationController?.pushViewController(SearchRegionViewController(), animated: true)
        }
    }
    
    extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return reviewData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == mainView.recommendCollectionView {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPageRecommendCollectionViewCell.identifier, for: indexPath) as? MainPageRecommendCollectionViewCell else {
                    fatalError()
                }
//                let arry2 = ["강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구","강남","송파구","성수동","중구"]
//                let arry = ["강남구","강서구","강북구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구","서대문구","마포구","강남구","강서구"]
//                cell.recommendLabel.text = arry[indexPath.item]
//                cell.recommendPicture.image = UIImage(named: arry2[indexPath.item])
//                let rid = ridArr?[indexPath.item] ?? ""                let cell = reviewUiView
//버튼저 레이어점 백그란운드

//                cell.regionLabel.text = "강남구"

                return cell
                
            } else if collectionView == mainView.reviewCollectionView {
                guard let secondCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPageReviewCollectionViewCell.identifier, for: indexPath) as? MainPageReviewCollectionViewCell else {
                    fatalError()
                }
                
//                let reviewTitle = reviewData[indexPath.item].title
//                let keyword = reviewData[indexPath.item].condition
//                let withKeyword = reviewData[indexPath.item].companion
//                let place = placeData[indexPath.item].town
//                let image = reviewData[indexPath.item].reviewImg
                let rid = ridArr?[indexPath.item] ?? ""
                let cell = secondCell.reviewUiView

                storageManager.bindViewOnStorageWithRid(rid: rid, reviewImgView: cell.img, title: cell.reviewTitleLabel, companion: cell.withKeywordLabel, condition: cell.conditionKeywordLabel, town: cell.regionLabel)
                    cell.regionLabel.text = "강남구"
//                secondCell.reviewUiView.withKeywordLabel.text = withKeyword
//                secondCell.reviewUiView.conditionKeywordLabel.text = keyword
//                secondCell.reviewUiView.reviewTitleLabel.text = reviewTitle
                secondCell.layer.cornerRadius = 30
                secondCell.layer.masksToBounds = true
                return secondCell
            }
            return UICollectionViewCell()
        }
    }
    
    extension MainViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == mainView.recommendCollectionView {
                return CGSize(width: 76, height: 110)
            } else if collectionView == mainView.reviewCollectionView {
                return CGSize(width: 353, height: 237)
            }
            return CGSize(width: 50, height: 50)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            if collectionView == mainView.recommendCollectionView {
                return 20
            } else if collectionView == mainView.reviewCollectionView {
                return 20
            }
            return 20
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if collectionView == mainView.recommendCollectionView {
                // 왼쪽 여백을 20으로 설정
                return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            } else if collectionView == mainView.reviewCollectionView {
                // 왼쪽 여백을 20으로 설정
                return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
    }

