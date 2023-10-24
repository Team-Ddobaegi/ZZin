//
//  KeywordCollectionViewCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/20.
//

import UIKit
import SnapKit
import Then

class KeywordCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let reuseIdentifer: String = "cell"
    
    let titleButton = UIButton().then {
        $0.setTitle("테스트 제목", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    var isButtonSelected = false
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleButton()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Settings
    
    func setTitleButton(){
        titleButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setButtonColorChange()
    }
    
    func setButtonColorChange(){
        if isButtonSelected {
            titleButton.layer.borderColor = ColorGuide.cherryTomato.cgColor
        } else {
            titleButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        }
    }
    
    // MARK: - ConfigureUI
    
    func configureUI() {
        contentView.addSubview(titleButton)
        
        titleButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc func buttonTapped() {
        print("키워드 셀 클릭")
        isButtonSelected.toggle()
        setButtonColorChange()
    }
    
}
