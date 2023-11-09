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
    let reviewCell = ReviewTableViewCell()
    private let mainView = MainView()
    
    var loadedRidAndPid: [String:[String]?] = [:]
    var placeData: [Place] = []
    var pidArr: [String]? = []
    var ridArr: [String]? = []
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
    
//    func fetchData() {
//        if let uid = uid {
//            FireStorageManager().getPidAndRidWithUid(uid: uid) { [self] result in
//                loadedRidAndPid = result
//                ridArr = loadedRidAndPid["ridArr"] ?? []
//                mainView.tableView.reloadData()
//            }
//        }
//    }
//    
//    func fetchPlaceData() {
//        FireStoreManager.shared.getPlaceData { data in
//            switch data {
//            case .success(let result):
//                self.placeData = result
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
}

extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        view.backgroundColor = .white
//        fetchData()
//        fetchPlaceData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let currentUser = Auth.auth().currentUser
        print("현재 유저입니다. -",currentUser)
        print("id도 있나요?", currentUser?.uid)
        print("id도 있나요?", currentUser?.email)
        setDelegate()
        setUI()
        mainView.delegate = self
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
        case 0: return 98
        case 1: return 245
        case 2: return 250
        default: return 200
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as! ReviewTableViewCell
            cell.dataBinding(data: ridArr)
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
        let alert = UIAlertController(title: "로그아웃", message: "앱을 떠나시겠어요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default) { _ in
            DispatchQueue.main.async {
                print("현재 유저입니다. -",currentUser)
                print("id도 있나요?", currentUser?.uid)
                print("id도 있나요?", currentUser?.email)
                
                try! Auth.auth().signOut()
                self.dismiss(animated: true)
            }
        }
        
        let cancel = UIAlertAction(title: "더 볼래요", style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
