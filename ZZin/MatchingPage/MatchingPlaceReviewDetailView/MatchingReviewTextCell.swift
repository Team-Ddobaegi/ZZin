
import UIKit
import SnapKit
import Then


// MARK: - 매칭업체 방문자 리뷰(텍스트)가 보여질 cell

class MatchingReviewTextCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingReviewTextCell"
    var textMessageViewHeightConstraint: Constraint?
    
    // 또배기 리뷰 텍스트가 들어갈 메세지뷰
    private let textMessageView = UIView().then {
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 25
    }
    
    private let ddobaegiLabel = UILabel().then {
        $0.text = "💬 또배기의 한마디"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    lazy var reviewTextLabel = UILabel().then{
        $0.text = ""
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .justified
    }

    lazy var reviewLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ddobaegiLabel, reviewTextLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        updateLabelHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Settings
    
    private func setView() {
        backgroundColor = .white
        
        configureUI()
    }
    
    
    //MARK: - configure UI
    
    func updateLabelText(_ text: String) {
        reviewTextLabel.text = text
        updateLabelHeight()
    }
    
    
    private func updateLabelHeight() {
        let labelSize = reviewTextLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 50, height: CGFloat.greatestFiniteMagnitude))
        reviewTextLabel.snp.remakeConstraints { make in
            make.height.equalTo(labelSize.height + 20)
        }
        textMessageViewHeightConstraint?.update(offset: labelSize.height + 100)
    }
    
    
    
    private func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews(){
        contentView.addSubview(textMessageView)
        textMessageView.addSubview(reviewLabelStackView)
    }
    
    private func setConstraints(){
        textMessageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        reviewLabelStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(28)
        }
    }
    
}
