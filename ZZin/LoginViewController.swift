//
//  loginViewController.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/15.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    //MARK: - UIComponent 선언
    private let logoView: UIImageView = {
        let image = UIImage(systemName: "photo")
        let iv = UIImageView()
        iv.image = image
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - Function 선언
    func configure() {
        view.backgroundColor = .white
        
        [logoView].forEach{view.addSubview($0)}
    }
    
    func setUI() {
        setLogo()
    }
    
    private func setLogo() {
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(124)
            make.width.equalTo(186)
            make.height.equalTo(90)
        }
    }
    
    deinit {
        print("로그인 페이지가 화면에서 내려갔습니다 - \(#function)")
    }
}

//MARK: - LifeCycle 선언
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("로그인 페이지 - \(#function)")
        
        configure()
        setUI()
    }
}
