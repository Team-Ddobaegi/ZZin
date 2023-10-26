//
//  MatchingReviewTextCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/25/23.
//

import UIKit
import SnapKit
import Then


// MARK: - 매칭업체 방문자 리뷰(텍스트)가 보여질 cell

class MatchingReviewTextCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Settings
    
    private func setView(){
        backgroundColor = .white
        
        configureUI()
    }
    
    // 텍스트 레이블에 텍스트를 설정하는 메서드
    func setReviewText(_ text: String) {
        reviewTextLabel.text = text
    }
    
    // 테스트 길이만큼 셀 높이를 계산
    static func calculateHeight(for text: String) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = text
        let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: .greatestFiniteMagnitude))
        return size.height + 150 // 적절한 여백을 추가한 높이를 반환
    }
    
    
    // MARK: - Properties
    
    static let identifier = "MatchingReviewTextCell"
    
    private var textMessageViewHeightConstraint: Constraint?
    
    // 또배기 리뷰 텍스트가 들어갈 메세지뷰
    private let textMessageView = UIView().then {
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 25
    }
    
    private let ddobaegiLabel = UILabel().then {
        $0.text = "또배기의 한마디"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    let reviewTextLabel = UILabel().then{
        $0.text = "일단 고기를 직접 구워주셔서 너무 좋음!! 편하게 구워주시는대로 먹을 수 있으니 회전율도 나름 빠르고 직원분도 친절하심:) 모둠한판으로 2인 먹었는데 생각보다 양이 괜찮아서 추가 안해도 됐었슴ㅎㅎ 된찌 서비스 주셔서 감동👍 물냉면은 적당히 맛있었는데 도시락 김치볶음밥은 뭔가 금 아쉬웠.. 그래도 메인인 고기는 최고!"
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    
    lazy var reviewLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ddobaegiLabel, reviewTextLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    
    
    //MARK: - configure UI
    
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
            $0.edges.equalToSuperview().inset(30)
        }
    }
}
