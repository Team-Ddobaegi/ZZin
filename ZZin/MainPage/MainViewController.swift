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
    private let scrollView = UIScrollView()
    
    lazy var reviewData: [Review]? = []
    lazy var dataTest1: [Review] = []
    lazy var dataTest2: [Review] = []
    lazy var dataTest3: [Review] = []
    lazy var dataTest4: [Review] = []
    lazy var dataTest5: [Review] = []


//    var reviews:[Review] = []
//    var resultTitle: String = ""
    //컨페니언 "페치플레이스윗키워드"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        rankButtonAction()
//        datafatch()
        fetchdata()
        setupUI()

//        reviewTitle = Review.title

    }
    

    func fetchdata() {
        
        FireStoreManager.shared.getReviewDatas { data in
            switch data {
            case.success(let result):
                self.reviewData = result
                self.dataTest1.append(result[0])
                self.dataTest2.append(result[1])
                self.dataTest3.append(result[2])
                self.dataTest4.append(result[3])
                self.dataTest5.append(result[4])

                print(result[0].kindOfFood)
//                print("===========================데이터\(self.dataTest1)")
                print("===========================데이터\(self.reviewData)")

            case.failure(let error):
                print(error)
            }
        }
    }
    
    //    func datafatch() {
    //
    //        FireStoreManager().getReviewData { data in
    //            if let result = data {
    //                self.resultTitle = result[0].title
    //            } else {
    //            }
    //        }
    //        print(resultTitle)
    //
    //    }
    
//        FireStoreManager.shared.fetchDataWithRid(rid: "yJE4OAYRhdoKCwlEqzKr") { (result) in
//            switch result {
//            case .success(let review):
//                print(review.title)  // 예시로 리뷰 제목을 출력
//            case .failure(let error):
//                print("Error fetching review: \(error.localizedDescription)")
//            }
//        }
//    }
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
            navigationController?.pushViewController(SearchRegionViewController(), animated: true)
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
            if let review = reviewData{
                
                var reviewTitle = reviewData?[indexPath.item].title
                secondCell.reviewUiView.reviewTitleLabel.text = reviewTitle
                print("\(reviewData?.count)--------------")
            }
//            secondCell.layer.borderWidth = 1.0
            secondCell.layer.cornerRadius = 30
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
            return 20
        } else if collectionView == mainView.reviewCollectionView {
            return 20
        }
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == mainView.recommendcollectionView {
            // 왼쪽 여백을 20으로 설정
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else if collectionView == mainView.reviewCollectionView {
            // 왼쪽 여백을 20으로 설정
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}

