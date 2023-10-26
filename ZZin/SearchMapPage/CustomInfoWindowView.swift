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
        backgroundColor = .clear

        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 30), cornerRadius: 10)
        path.move(to: CGPoint(x: 45, y: 30))
        path.addLine(to: CGPoint(x: 50, y: 40))
        path.addLine(to: CGPoint(x: 55, y: 30))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1
        
        layer.insertSublayer(shapeLayer, at: 0)

        addSubview(placeNameLabel)
        
        placeNameLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-5)
        }
    }
}
