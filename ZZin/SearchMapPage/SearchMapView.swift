import UIKit
import NMapsMap
import SnapKit

class SearchMapView: UIView {
    private var naverMapView: NMFNaverMapView = NMFNaverMapView()
    
    lazy var searchCurrentLocationButton = UIButton().then {
        $0.setTitle("이 지역에서 재검색", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.backgroundColor = .systemRed
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    var mapView: NMFMapView {
        return naverMapView.mapView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(naverMapView)
        addSubview(searchCurrentLocationButton)
        
        naverMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchCurrentLocationButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(180)
        }
        mapView.positionMode = .normal
    }
}


