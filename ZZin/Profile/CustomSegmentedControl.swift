//
//  CustomSegmentedControl.swift
//  ZZin
//
//  Created by 남보경 on 2023/10/29.
//

import UIKit
import Then
import SnapKit

class CustomSegmentedControl: UIView {

    // MARK: - Properties

    private var buttonTitles: [String]
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    var textColor: UIColor = .lightGray
    var selectorViewColor: UIColor = ColorGuide.main
    var selectedButtonColor: UIColor = ColorGuide.main

    var onValueChanged: ((_ index: Int) -> Void)?

    // MARK: - Initialization

    init(frame: CGRect, buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        createButtons()
        configureSelectorView()
    }

    private func createButtons() {
        for (_, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            buttons.append(button)
        }

        buttons[0].setTitleColor(selectedButtonColor, for: .normal)

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureSelectorView() {
        let selectorWidth = self.frame.width / CGFloat(buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height - 4, width: selectorWidth, height: 4))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }

    // MARK: - Actions

    @objc func buttonTapped(_ sender: UIButton) {
        for (index, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorStartPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectorView.frame.origin.x = selectorStartPosition
                })
                btn.setTitleColor(selectedButtonColor, for: .normal)
                onValueChanged?(index)
            }
        }
    }
}
