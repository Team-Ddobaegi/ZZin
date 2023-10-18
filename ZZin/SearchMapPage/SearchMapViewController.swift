import UIKit
import NMapsMap
import SnapKit

class SearchMapViewController: UIViewController {
    // MARK: - Property
    private var searchView = SearchView()
    
    private lazy var backButton = UIButton().then {
        let iconImage = UIImage(systemName: "arrowshape.backward.fill")
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = .systemRed
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gridButtonTapped() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeSearchView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - UI Setting
    func changeSearchView() {
        searchView.mapButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
        searchView.mapButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        view.backgroundColor = .darkGray
        
        let searchMapView = SearchMapView(frame: view.frame)
        
        view.addSubview(searchView)
        view.addSubview(searchMapView)
        searchView.addSubview(backButton)

        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(247)
        }
        
        searchMapView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(searchView.mapButton.snp.centerY)
            $0.leading.equalToSuperview().offset(20)
        }
    }
}


