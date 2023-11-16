//
//  OkVC.swift
//  ZZin
//
//  Created by clone1 on 11/7/23.
//

import Foundation
import UIKit
import Then
import FirebaseAuth

protocol LogoutDelegate: class {
    func onTapClose()
    func onTapOk()
}

class LogoutViewController: UIViewController {
    
    weak var delegate: LogoutDelegate?
    
    let bgView = UIView().then {
        $0.backgroundColor = .customBackground
        $0.layer.cornerRadius = 20
    }
    
    var titleLabel = UILabel().then {
        $0.textColor = .label
        $0.text = "로그아웃"
        $0.font = .systemFont(ofSize: 25, weight: .bold)
    }
    
    var explanationLabel = UILabel().then {
        $0.textColor = .label
        $0.text = "로그아웃 하시겠습니까?"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    var okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 30
        if let titleLabel = $0.titleLabel {
            let semiBoldFont = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .semibold)
            $0.titleLabel?.font = semiBoldFont
        }
    }
    
    var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(ColorGuide.main, for: .normal)
        $0.backgroundColor = .systemGray4
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 30
        if let titleLabel = $0.titleLabel {
            let semiBoldFont = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .semibold)
            $0.titleLabel?.font = semiBoldFont
        }
    }
    
    static func instance() -> LogoutViewController {
        return LogoutViewController(nibName: nil, bundle: nil).then {
            $0.modalPresentationStyle = .overFullScreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(bgView)
        view.addSubview(titleLabel)
        view.addSubview(explanationLabel)
        view.addSubview(okButton)
        view.addSubview(cancelButton)
        
        okButton.addTarget(self, action: #selector(onTapOk), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(onTapClose), for: .touchUpInside)
        
        bgView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bgView).inset(30)
            $0.centerX.equalTo(bgView)
        }
        
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(50)
            $0.centerX.equalTo(bgView)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(explanationLabel).offset(50)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(350)
            $0.height.equalTo(60)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(okButton).offset(70)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(350)
            $0.height.equalTo(60)
        }
    }
    
    @objc func onTapOk() {
        do {
            try! Auth.auth().signOut()
            self.dismiss(animated: true) {
                //                  let loginpage = LoginViewController()
                //                  loginpage.modalPresentationStyle = .fullScreen
                //                  self.present(loginpage, animated: true)
            }
        } catch {
            print("로그아웃하는데 에러가 있었습니다.")
        }
        delegate?.onTapOk()
    }
    
    @objc func onTapClose() {
        delegate?.onTapClose()
        dismiss(animated: true, completion: nil)
    }
}
