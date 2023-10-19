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
        
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self

        tableView.alwaysBounceVertical = true
        
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.identifier)
        
        let placeCell = UINib(nibName: "InfoPageCollectionView", bundle: nil)
        tableView.register(placeCell, forCellReuseIdentifier: ZZinListTableViewCell.identifier)
        
        tableView.reloadData()
        tableView.sectionHeaderTopPadding = 0
        
        self.title = "마이페이지"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        tableView.separatorStyle = .none
    }
    
    // TableView 설정
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let collectionCellRowCount = Int(zzinBasicInfos.count / 2)
        switch indexPath.section {
        case 0: return 170
        case 1: return CGFloat(240 * collectionCellRowCount)
        default: return 228
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {2}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier) as! UserInfoTableViewCell
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ZZinListTableViewCell.identifier, for: indexPath) as! ZZinListTableViewCell
            cell.selectionStyle = .none
            return cell
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // section header 반환
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard section == 1 else {
                return nil;
            }
            let view = SegmentedControlView()
            view.backgroundColor = .systemBackground
        
            return view
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {zzinBasicInfos.count}

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
