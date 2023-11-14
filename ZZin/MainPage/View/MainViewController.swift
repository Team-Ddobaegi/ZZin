//
//  MainViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    // MARK: - 전역 변수
    let storageManager = FireStorageManager()
    let dataManager = FireStoreManager()
    let reviewCell = ReviewTableViewCell()
    private let mainView = MainView()
    
    var loadedRidAndPid: [String:[String]?] = [:]
    var placeData: [Place] = []
    var reviewData: [Review] = []
    // current user로 변경될 수 있도록 로그인에서 수정 🚨
    let uid = Auth.auth().currentUser?.uid

    func setDelegate() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func setUI() {
        mainView.tableView.showsVerticalScrollIndicator = false
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fetchReviewData() {
        dataManager.getReviewData { result in
            switch result {
            case .success(let review):
                print("======= 이게 데이터다 ========",review)
                self.reviewData = review
            case .failure(let error):
                print("=========== 에러가 발생했습니다. - \(error.localizedDescription) =========== ")
            }
        }
    }
}

extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        view.backgroundColor = .white
        fetchReviewData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setUI()
        mainView.delegate = self
        LocationService.shared.startUpdatingLocation()
    }
}

//MARK: - 테이블뷰 셀
extension MainViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 영역별 높이 다르게 설정
        switch indexPath.section {
        case 0: return 100
        case 1: return 280
        case 2: return 240
        default: return 200
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: LocalTableViewCell.identifier, for: indexPath) as! LocalTableViewCell
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as! ReviewTableViewCell
            cell.selectionStyle = .none
//            guard let rid = reviewData[indexPath.row]?.rid else { return cell }
//            storageManager.bindViewOnStorageWithRid(rid: rid, reviewImgView: cell.imageView, title: cell.textLabel, companion: <#T##UILabel?#>, condition: <#T##UILabel?#>, town: nil)
//            cell.recieveData(data: reviewData)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableviewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainHeaderView.identifier) as? MainHeaderView
        tableviewHeaderView?.configure(with: section)
        return tableviewHeaderView
    }
}

extension MainViewController: MainViewDelegate {
    func didTapLogout() {
        print("로그아웃 버튼이 눌렸습니다.")
        let currentUser = Auth.auth().currentUser
        print("현재 유저입니다. -",currentUser)
        print("id도 있나요?", currentUser?.uid)
        print("email도 있나요?", currentUser?.email)
        print("nickname도 있나요?", currentUser?.displayName)
        print("이미지는요?", currentUser?.photoURL)
        
        let alert = UIAlertController(title: "로그아웃", message: "앱을 떠나시겠어요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default) { _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                try! Auth.auth().signOut()
            }
        }
        
        let cancel = UIAlertAction(title: "더 볼래요", style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
