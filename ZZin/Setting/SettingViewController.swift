
import UIKit
import SnapKit
import Then

class SettingViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .customBackground
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .customBackground
        self.navigationController?.navigationBar.topItem?.title = "설정"
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.backButtonTitle = "계정"
        self.navigationItem.leftBarButtonItem?.tintColor = .label
//        let backButtonImage = UIImage(named: "arrow.left")?.withRenderingMode(.alwaysOriginal)

        setupView()
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        header.backgroundColor = .customBackground
        
        let headerLabel = UILabel(frame: header.bounds)
        headerLabel.textAlignment = .center
        header.addSubview(headerLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupView() {
        view.addSubview(tableView)
        
        tableView.register(SettingViewControllerCell.self, forCellReuseIdentifier: SettingViewControllerCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.separatorStyle = .none
    }
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil // Return nil for the header of the first section
        } else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
            headerView.backgroundColor = .customBackground

            let headerLabel = UILabel(frame: headerView.bounds)
            headerLabel.textAlignment = .left
            headerLabel.text = "정보"
            headerLabel.font = .systemFont(ofSize: 13, weight: .bold)
            headerLabel.textColor = .systemGray

            headerView.addSubview(headerLabel)
            
            headerLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(30)
                $0.bottom.equalTo(5)
            }
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "정보"
    }
    
    // 파라미터로 주어진 섹션 별 보여줄 필요가 있는 셀들의 개수를 반환한다. (필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //스위치로 각 섹션에 들어가는 셀정의
    }
    
    // IndexPath(Section, Row)에 해당하는 셀을 반환한다. (필수)
    // 해당 메서드에서 실제 셀에 필요한 조작을 진행하여 반환하도록 한다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewControllerCell.identifier,for: indexPath) as! SettingViewControllerCell
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.leadingImage.image = UIImage(systemName: "person.fill")
            cell.text.textAlignment = .left
            cell.text.text = "계정"
            cell.appVersionText.isHidden = true
            cell.separatorInset = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
        } else if indexPath.row == 0 && indexPath.section == 1 {
            cell.leadingImage.image = UIImage(systemName: "info.circle.fill")
            cell.text.text = "앱버전"
            //            cell.text = .underline
            cell.trailingImage.isHidden = true
            cell.separatorInset = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        return cell
    }
    
    // 섹션의 개수를 반환한다. 디폴트 값은 1.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            // Navigate to AccountSettingViewController when the first cell in the first section is tapped
            let accountSettingVC = AccountSettingViewController() // Replace with the actual initialization of your AccountSettingViewController
            navigationController?.pushViewController(accountSettingVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
