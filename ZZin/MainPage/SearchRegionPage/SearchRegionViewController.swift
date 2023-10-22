import UIKit

class SearchRegionViewController: UIViewController {
    
    var tableView: UITableView!
    
    var arr = [
        "Zedd", "Alan Walker", "David Guetta", "Avicii", "Marshmello", "Steve Aoki", "R3HAB",
        "Armin van Buuren", "Skrillex", "Illenium", "The Chainsmokers", "Don Diablo", "Afrojack",
        "Tiesto", "KSHMR", "DJ Snake", "Kygo", "Galantis", "Major Lazer", "Vicetone"
    ]
    
    var filteredArr: [String] = []
    
    var isFiltering: Bool {
        if let searchController = self.navigationItem.searchController {
            return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = ColorGuide.main

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self

        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem(title: "뒤로", style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton

    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

extension SearchRegionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        if text.isEmpty {
            // 검색어가 비어있을 때는 모든 데이터를 숨김
            filteredArr = []
        } else {
            // 검색어가 입력되면 해당 검색어로 시작하는 항목만 표시
            filteredArr = arr.filter { $0.localizedCaseInsensitiveContains(text) && $0.lowercased().hasPrefix(text) }
        }
        
        tableView.reloadData()
    }
}

extension SearchRegionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredArr.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if isFiltering {
            cell.textLabel?.text = filteredArr[indexPath.row]
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
}
