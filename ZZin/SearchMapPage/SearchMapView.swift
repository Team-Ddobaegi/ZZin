import UIKit
import NMapsMap

class SearchMapView: UIView {
    let naverMapView: NMFNaverMapView
    
    override init(frame: CGRect) {
        naverMapView = NMFNaverMapView(frame: frame)
        super.init(frame: frame)
        addSubview(naverMapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
