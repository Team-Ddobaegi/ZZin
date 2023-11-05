//
//  MainViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit

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
    let uid = "bo_bo_@kakao.com"

    func setDelegate() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func setUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fetchData() {
        FireStorageManager().getPidAndRidWithUid(uid: uid) { [self] result in
            loadedRidAndPid = result
            ridArr = loadedRidAndPid["ridArr"] ?? []
            mainView.tableView.reloadData()
        }
    }
    
    func fetchPlaceData() {
        FireStoreManager.shared.getPlaceData { data in
            switch data {
            case .success(let result):
                self.placeData = result
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        fetchPlaceData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setUI()
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
