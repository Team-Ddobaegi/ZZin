//
//  CustomViewForPostPage.swift
//  ZZin
//
//  Created by 남보경 on 2023/11/02.
//

import UIKit
import Then
import SnapKit

class SecondHeading: UILabel {
    var label = UILabel().then{
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 25, weight: .bold)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Title: UILabel {
    var label = UILabel().then{
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTextField: UIView, UITextFieldDelegate {
    
    var textField = UITextField().then{
        $0.textColor = .label
        $0.borderStyle = .none
        $0.layer.borderWidth = 0
        $0.placeholder = "맛집 정보 확인을 먼저 진행해주세요."
        $0.layer.cornerRadius = 12
        $0.layer.backgroundColor = UIColor.quaternarySystemFill.cgColor
        $0.autocorrectionType = .no // 자동 수정 활성화 여부
        $0.spellCheckingType = .no  // 맞춤법 검사 활성화 여부
        $0.autocapitalizationType = .none  // 자동 대문자 활성화 여부
        $0.clearButtonMode = .never // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.isUserInteractionEnabled = false
        $0.clearsOnBeginEditing = false
        $0.addLeftPadding()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        textField.delegate = self
        addSubview(textField)
        textField.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
            $0.height.equalTo(45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // 키보드 내리면서 동작
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}


class FindPlaceButton: UIButton {
    var wrapVeiw = UIView().then{
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 15
    }
    
    var buttonLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(wrapVeiw)
        wrapVeiw.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        wrapVeiw.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
