import UIKit
import NMapsMap
import SnapKit

class SearchMapView: UIView {
    private let naverMapView: NMFNaverMapView
    var mapView: NMFMapView {
        return naverMapView.mapView
    }

    override init(frame: CGRect) {
        naverMapView = NMFNaverMapView()
        super.init(frame: frame)
        addSubview(naverMapView)
        naverMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mapView.positionMode = .normal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


