
import UIKit
import SnapKit
import Then

class MainHeaderView: UITableViewHeaderFooterView {
    static let identifier = "MainHeaderView"
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    // switch section구분
    func configure(with section: Int) {
        switch section {
        case 0:
            let text = "로컬들이 추천해 주는 내 주변 찐 맛집"
            let biggerFont = FontGuide.size19Bold
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
            attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
            titleLabel.attributedText = attributedStr
        case 1:
            let text = "로컬들의 실시간 맛집 찐 리뷰"
            let biggerFont = FontGuide.size19Bold
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(.font, value: biggerFont, range: (text as NSString).range(of: "찐"))
            attributedStr.addAttribute(.foregroundColor, value: ColorGuide.main, range: (text as NSString).range(of: "찐"))
            titleLabel.attributedText = attributedStr
        default:
            titleLabel.text = "우리들의 찐 맛집"
        }
    }
}
