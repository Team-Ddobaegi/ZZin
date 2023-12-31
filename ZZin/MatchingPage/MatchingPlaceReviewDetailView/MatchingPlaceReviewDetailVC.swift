
import UIKit

class MatchingPlaceReviewDetailVC: UIViewController {
    
    //MARK: - Properties
    
    private let matchingPlaceReviewDetailView = MatchingPlaceReviewDetailView()
    var reviewID: String?
    lazy var updateText = "업데이트 확인용 텍스트라벨"
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    // MARK: - Settings
    
    private func setView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setCostumCell()
        setTableViewAttribute()
        configureUI()
    }

    
    private func setCostumCell() {
        // 커스텀 셀 선언
        matchingPlaceReviewDetailView.setMatchingPlaceReviewTableView.register(MatchingThumbnailCell.self, forCellReuseIdentifier: MatchingThumbnailCell.identifier)
        matchingPlaceReviewDetailView.setMatchingPlaceReviewTableView.register(MatchingReviewPhotoCell.self, forCellReuseIdentifier: MatchingReviewPhotoCell.identifier)
        matchingPlaceReviewDetailView.setMatchingPlaceReviewTableView.register(MatchingReviewTextCell.self, forCellReuseIdentifier: MatchingReviewTextCell.identifier)
    }
    
    private func setTableViewAttribute(){
        // 매칭 업체 페이지 테이블뷰
        matchingPlaceReviewDetailView.setMatchingPlaceReviewTableView.delegate = self
        matchingPlaceReviewDetailView.setMatchingPlaceReviewTableView.dataSource = self
        matchingPlaceReviewDetailView.setMatchingPlaceReviewTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        matchingPlaceReviewDetailView.setMatchingPlaceReviewTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    
    // MARK: - Actions
    
    @objc private func xMarkButtonTapped(){
        print("매칭 업체 페이지로 돌아갑니다.")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - configureUI
    
    func configureUI(){
        view.addSubview(matchingPlaceReviewDetailView)
        
        matchingPlaceReviewDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}



// MARK: - TableView

extension MatchingPlaceReviewDetailVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return MatchingThumbnailCell.cellHeight()
        case 1:
            return MatchingReviewPhotoCell.cellHeight()
        case 2:
            return UITableView.automaticDimension
          
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {3}
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            // 매칭 리뷰 썸네일
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingThumbnailCell.identifier) as! MatchingThumbnailCell
            cell.selectionStyle = .none
            cell.xMarkButton.addTarget(self, action: #selector(xMarkButtonTapped), for: .touchUpInside)
            
            FireStorageManager().bindViewOnStorageWithRid(rid: reviewID ?? "", reviewImgView: cell.review.img, title: cell.review.reviewTitleLabel, companion: cell.review.withKeywordLabel, condition: cell.review.conditionKeywordLabel, town: cell.review.regionLabel)
            
            
            return cell
            
        case 1:
            // 매칭 리뷰 사진
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingReviewPhotoCell.identifier, for: indexPath) as! MatchingReviewPhotoCell
            cell.selectionStyle = .none
          
            FireStoreManager.shared.fetchDataWithRid(rid: reviewID ?? "") { (result) in
                switch result {
                case .success(let review):
                    let reviewImg = review.reviewImg
                    FireStorageManager().bindPlaceImgWithPath(path: reviewImg?[0], imageView: cell.photoImageView)
                    
                case .failure(let error):
                    print("Error fetching review: \(error.localizedDescription)")
                }
            }
            
            return cell
            
        case 2:
            // 매칭 리뷰 컨텐츠
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchingReviewTextCell.identifier, for: indexPath) as! MatchingReviewTextCell

            FireStoreManager.shared.fetchDataWithRid(rid: reviewID ?? "") { [weak self] result in
                    switch result {
                    case .success(let review):
                        let content = review.content
                        cell.reviewContentLabel.text = content
                        cell.updateLabelText(content)

                        print("$$$$$$$$ 업데이트 확인", cell.reviewContentLabel.text ?? "")

                        // 테이블 뷰 업데이트 (한 번만 호출)
                        DispatchQueue.main.async {
                           tableView.beginUpdates()
                           tableView.endUpdates()
                        }
                        
                    case .failure(let error):
                        print("Error fetching review: \(error.localizedDescription)")
                    }
                }
            
            return cell
        
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
}

