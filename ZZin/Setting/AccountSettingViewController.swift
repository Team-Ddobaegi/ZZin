//
//  File.swift
//  ZZin
//
//  Created by clone1 on 11/7/23.
//

import UIKit
import Then
import SnapKit

class AccountSettingViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .customBackground
        return tableview
    }()
        
    let bgView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0
    }
    
    static func instance() -> AccountSettingViewController {
        return AccountSettingViewController(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setupView() {
        view.addSubview(tableView)

        tableView.register(AccountSettingViewControllerCell.self, forCellReuseIdentifier: AccountSettingViewControllerCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.separatorStyle = .none
    }
        
    private func addDim() {
        view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.bgView.alpha = 0.3
        }
    }
    
    private func removeDim() {
        DispatchQueue.main.async { [weak self] in
            self?.bgView.removeFromSuperview()
        }
    }
}

extension AccountSettingViewController: LogoutDelegate {
    func onTapOk() {
        self.removeDim()
        let loginpage = LoginViewController()
        loginpage.modalPresentationStyle = .fullScreen
        self.present(loginpage, animated: true)
    }
    
    func onTapClose() {
        self.removeDim()
    }
}

extension AccountSettingViewController: WithdrawalDelegate {
    func onTapClose2() {
        self.removeDim()
    }
}

extension AccountSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 파라미터로 주어진 섹션 별 보여줄 필요가 있는 셀들의 개수를 반환한다. (필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //스위치로 각 섹션에 들어가는 셀정의
    }
    
    // IndexPath(Section, Row)에 해당하는 셀을 반환한다. (필수)
    // 해당 메서드에서 실제 셀에 필요한 조작을 진행하여 반환하도록 한다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingViewControllerCell.identifier,for: indexPath) as! AccountSettingViewControllerCell
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.leadingImage.image = UIImage(systemName: "rectangle.portrait.and.arrow.right.fill")
            cell.text.textAlignment = .left
            cell.text.text = "로그아웃"
            cell.separatorInset = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
        } else if indexPath.row == 0 && indexPath.section == 1 {
            cell.leadingImage.image = UIImage(systemName: "trash")
            cell.leadingImage.tintColor = .red
            cell.text.text = "회원탈퇴"
            //            cell.text = .underline
            cell.trailingImage.isHidden = true
            cell.text.textColor = .red
            cell.separatorInset = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.leadingImage.snp.makeConstraints {
                $0.width.height.equalTo(35)
            }
        }
        return cell
    }
    
    // 섹션의 개수를 반환한다. 디폴트 값은 1.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let bulletinBoardVC = LogoutViewController.instance()
            
            bulletinBoardVC.delegate = self
            addDim()
            present(bulletinBoardVC, animated: true, completion: nil)

        case 1:
            let cbulletinBoardVC = WithdrawalViewController.instance()
            
            cbulletinBoardVC.delegate = self
            addDim()
            present(cbulletinBoardVC, animated: true, completion: nil)

        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
