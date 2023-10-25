import UIKit
import SnapKit
import NMapsMap

class CustomInfoWindowView: UIView {
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집 이름"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }
    
    func setupUI() {
        backgroundColor = .lightGray
        
        addSubview(placeNameLabel)
        
        placeNameLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
}
