import UIKit
import NMapsMap
import SnapKit

class SearchMapViewController: UIViewController {

    private var searchView = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setupUI()
    }
    
    func setDelegate() {
        self.tabBarController?.delegate = self
    }
    
    func setupUI() {
        view.backgroundColor = .darkGray
        
        let searchMapView = SearchMapView(frame: view.frame)
        
        view.addSubview(searchView)
        view.addSubview(searchMapView)

        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        searchMapView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchMapViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is SearchMapViewController {
            tabBarController.tabBar.isHidden = true
        } else {
            tabBarController.tabBar.isHidden = false
        }
        
        return true
    }
}
