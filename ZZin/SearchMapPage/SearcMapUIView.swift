import UIKit
import NMapsMap
import SnapKit

class SearchMapUIView: UIView {
    
    var matchingView = MatchingView()
    var storeCardView = StoreCardView()
    var searchMapView = SearchMapView()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let iconImage = UIImage(systemName: "arrowshape.backward.fill")
        button.setImage(iconImage, for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    lazy var gpsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        let gpsIcon = UIImage(systemName: "location.fill")
        button.setImage(gpsIcon, for: .normal)
        button.tintColor = .systemRed
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 5
        button.clipsToBounds = false
        return button
    }()
    
    let resetFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("필터 초기화", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var currentLocationButton = UIButton().then {
        let button = UIButton()
        $0.setTitle("이 지역에서 재검색", for: .normal)
    }
    
    func changeSearchView() {
        matchingView.mapButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        changeSearchView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(matchingView)
        addSubview(searchMapView)
        addSubview(storeCardView)
        matchingView.addSubview(resetFilterButton)
        matchingView.addSubview(backButton)
        searchMapView.addSubview(gpsButton)
        
        matchingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(232)
        }
        
        searchMapView.snp.makeConstraints {
            $0.top.equalTo(matchingView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(matchingView.mapButton.snp.centerY)
            $0.leading.equalToSuperview().offset(20)
        }
        
        gpsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(storeCardView.snp.top).offset(-50)
            $0.width.height.equalTo(40)
        }
        
        storeCardView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
        resetFilterButton.snp.makeConstraints {
            $0.leading.equalTo(matchingView.matchingNotiLabel.snp.trailing).offset(10)
            $0.top.equalTo(matchingView.matchingNotiLabel.snp.top)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
    }
}
