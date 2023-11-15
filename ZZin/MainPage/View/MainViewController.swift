//
//  MainViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainView = MainView()
    let storageManager = FireStorageManager()
    let dataManager = FireStoreManager()
    private let mainView = MainView()    
    var reviewData: [Review] = []
    var placeData: [Place] = []
    // current user로 변경될 수 있도록 로그인에서 수정 🚨
    let uid = Auth.auth().currentUser?.uid
    
    
    
    // MARK: - Settings
    
    func setTableViewAttribute() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.showsVerticalScrollIndicator = false
    }
    
    func fetchReviewData() {
        dataManager.getReviewData { result in
            switch result {
            case .success(let review):
                print("======= 이게 데이터다 ========",review)
                self.reviewData = review
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print("=========== 에러가 발생했습니다. - \(error.localizedDescription) =========== ")
            }
        }
    }
    
    func fetchPlaceData() {
        dataManager.getPlaceData { result in
            switch result {
            case .success(let place):
                print("======= 이게 데이터다 ========",place)
                self.placeData = place
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print("=========== 에러가 발생했습니다. - \(error.localizedDescription) =========== ")
            }
        }
    }
    
    // MARK: - Configure UI
    
    func setUI() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}



// MARK: - Life Cycles

extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        navigationController?.setNavigationBarHidden(true, animated: animated)
        view.backgroundColor = .white
        fetchReviewData()
        fetchPlaceData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewAttribute()
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
        case 1: return 250
        case 2: return 240
        default: return 200
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 섹션 헤더가 화면 위로 스크롤되지 않도록 고정
        if scrollView.contentOffset.y < sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
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
            cell.recieveData(full: placeData)
            cell.localCollectionView.reloadData()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
            cell.recieveData(full: placeData)
            cell.buttonCollectionView.reloadData()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as! ReviewTableViewCell
            cell.recieveData(data: reviewData)
            cell.reviewCollectionView.reloadData()
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
            
            do {
                try! Auth.auth().signOut()
                self.dismiss(animated: true) {
                    let loginpage = LoginViewController()
                    loginpage.modalPresentationStyle = .fullScreen
                    self.present(loginpage, animated: true)
                }
            } catch {
                print("로그아웃하는데 에러가 있었습니다.")
            }
        }
        
        let cancel = UIAlertAction(title: "더 볼래요", style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
