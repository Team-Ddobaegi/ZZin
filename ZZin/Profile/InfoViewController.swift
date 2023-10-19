//
//  InfoViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import SnapKit
import Then

class InfoViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "마이페이지"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self

        tableView.alwaysBounceVertical = true
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.identifier)
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        
        let placeCell = UINib(nibName: "InfoPageCollectionView", bundle: nil)
        tableView.register(placeCell, forCellReuseIdentifier: ZZinListTableViewCell.identifier)
        
        tableView.sectionHeaderTopPadding = 0
        
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        tableView.reloadData()
        print("reload 완료")
    }
    // TableView 설정
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let zzinPlaceCount = zzinRecommandations.count
        let zzinListCellHeight = 228
        let collectionViewLineSpacing = 16
        let reviewCellHeight =  237
        let spacingBetweenTableViewCell = 10
        let sectionHeaderHeight = 60
        switch indexPath.section {
        case 0: return 170
        case 1:
            return CGFloat(((zzinListCellHeight + collectionViewLineSpacing) * zzinPlaceCount) / 2) + 30
        case 2: return CGFloat(reviewCellHeight)
        default: return 170
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {3}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2: return 2 // 추후 데이터 수로 변경
        default: return 1
        }
       
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier) as! UserInfoTableViewCell
            cell.selectionStyle = .none
            return cell
        case 1:
            let zzinCell = tableView.dequeueReusableCell(withIdentifier: ZZinListTableViewCell.identifier, for: indexPath) as! ZZinListTableViewCell
                zzinCell.selectionStyle = .none
            return zzinCell
        case 2:
            let reviewCell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as! ReviewTableViewCell
            reviewCell.selectionStyle = .none
            return reviewCell
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // section header 반환
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SegmentedControlView()
        header.backgroundColor = .systemBackground
        switch section {
            case 1:
            header.switchButtonIndex(0)
            return  header
            case 2:
            header.switchButtonIndex(1)
            return  header
            default:
            return  nil
        }
    }

        // section header 높이 설정
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 60
    }
}


// collectionView가 TableViewCell이 되는 부분
class ZZinListTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    static let identifier = "ZZinListTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

        registerXib()
        registerDelegate()
    }
    
    private func registerXib(){
        let storyNib = UINib(nibName: "InfoPageZZinCollectionCell", bundle: nil)
            collectionView.register(storyNib, forCellWithReuseIdentifier: ZZinCollectionViewCell.identifier)
    }
        
    private func registerDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 16, bottom: 30, right: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // collectionViewCell 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 228)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {zzinRecommandations.count}

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZZinCollectionViewCell.identifier, for: indexPath) as! ZZinCollectionViewCell
        return cell
    }
}

// dummy
let zzinBasicInfos : [ZZinBasicInfo] = [zzin1, zzin2, zzin3, zzin4, zzin5, zzin6, zzin7, zzin8]

let zzin1 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")
let zzin2 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")
let zzin3 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")
let zzin4 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")
let zzin5 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")
let zzin6 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")
let zzin7 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")
let zzin8 : ZZinBasicInfo = ZZinBasicInfo(registerDate: Date(), id: UUID(), name: "오구당당 부평본점", address: "인천 부평구 경원대로1377번길 47", lat: 126.722032, long: 37.4934269, RepresentativeImageURL: "ogudangdang")

let zzinRecommandations : [ZZinRecommendation] = [zzinReccmmandation1, zzinReccmmandation2, zzinReccmmandation3, zzinReccmmandation4]

let zzinReccmmandation1 : ZZinRecommendation = ZZinRecommendation(basicInfo: zzin1, companys: .withFamily, conditions: .lotsOfSideDishes, category: .korean, imageURL: "ogudangdang_review")
let zzinReccmmandation2 : ZZinRecommendation = ZZinRecommendation(basicInfo: zzin1, companys: .withFamily, conditions: .lotsOfSideDishes, category: .korean, imageURL: "ogudangdang_review")
let zzinReccmmandation3 : ZZinRecommendation = ZZinRecommendation(basicInfo: zzin1, companys: .withFamily, conditions: .lotsOfSideDishes, category: .korean, imageURL: "ogudangdang_review")
let zzinReccmmandation4 : ZZinRecommendation = ZZinRecommendation(basicInfo: zzin1, companys: .withFamily, conditions: .lotsOfSideDishes, category: .korean, imageURL: "ogudangdang_review")
