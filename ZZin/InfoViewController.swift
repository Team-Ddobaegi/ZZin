//
//  InfoViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.title = "마이페이지"
    }
    
    // TableView 설정
    
    func numberOfSections(in tableView: UITableView) -> Int {2}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1 // 데이터 수에 맞게 변경
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier) as! UserInfoTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoLocalListTableViewCell.identifier) as! InfoLocalListTableViewCell
            return cell
        default: return UITableViewCell()
        }
    }

}

class UserInfoTableViewCell: UITableViewCell {
    static let identifier = "userInfoCell"
    
}
// collectionView가 TableViewCell이 되는 부분
class InfoLocalListTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    static let identifier = "localListTableViewCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {1}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
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
