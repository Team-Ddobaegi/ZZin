//
//  LocationPickerView.swift
//
//
//  Created by t2023-m0045 on 10/23/23.
//

import UIKit

class MatchingLocationPickerView: UIView {
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Properties
    
    public let pickerView = UIPickerView().then {
        $0.backgroundColor = .white
        $0.tintColor = ColorGuide.main
    }
    
    private let noticeLabel = UILabel().then {
        $0.text = "어디로\n가시나요?"
        $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    public let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    
    // MARK: - ConfigureUI
    
    private func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews(){
        addSubview(noticeLabel)
        addSubview(pickerView)
        addSubview(confirmButton)
    }
    
    private func setConstraints(){
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(25)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-50)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(60)
        }
    }
}
