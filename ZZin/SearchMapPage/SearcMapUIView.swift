//import UIKit
//import NMapsMap
//import SnapKit
//
//class SearchMapUIView: UIView {
//    
//    let searchView = SearchView()
//    let storeCardView = StoreCardView()
//    let mapView = NMFMapView(frame: .zero)
//    
//    lazy var backButton: UIButton = {
//        let button = UIButton()
//        let iconImage = UIImage(systemName: "arrowshape.backward.fill")
//        button.setImage(iconImage, for: .normal)
//        button.tintColor = .systemRed
//        return button
//    }()
//    
//    lazy var gpsButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        button.layer.cornerRadius = 20
//        let gpsIcon = UIImage(systemName: "location.fill")
//        button.setImage(gpsIcon, for: .normal)
//        button.tintColor = .systemRed
//        
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowOpacity = 0.1
//        button.layer.shadowRadius = 5
//        button.clipsToBounds = false
//        return button
//    }()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupUI() {
//        addSubview(searchView)
//        addSubview(mapView)
//        addSubview(storeCardView)
//        addSubview(gpsButton)
//        searchView.addSubview(backButton)
//        
//    }
//}
