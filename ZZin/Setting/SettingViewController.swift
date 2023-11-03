import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    private var tableView: UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubView()
        autoLayout()
    }
    
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    private func autoLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewControllerCell.identifier, for: indexPath) as! SettingViewControllerCell
        cell.label.text = "Cell : \(indexPath.row)"
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select \(indexPath.row)")
    }
}

class SettingViewControllerCell: UITableViewCell {
    
    static let identifier = "SettingViewControllerCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Cell"
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(label)
    }
    
    private func autoLayout() {
        label.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(5)
            $0.top.equalTo(contentView.snp.top).offset(5)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-5)
        }
    }
}
