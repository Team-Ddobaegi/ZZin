//
//  SegmentedControlHeader.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/18.
//

import UIKit

var buttonIndex = 0

class SegmentedControlView: UIView {
    let wrap = UIView()
    
    let firstButton = UIButton().then {
        $0.setTitle("맛집 추천", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
    }
    
    let secondButton = UIButton().then {
        $0.setTitle("리뷰", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.setTitleColor(.gray, for: .normal)
        $0.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
    }
    
    let thirdButton = UIButton().then {
        $0.setTitle("리워드", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.setTitleColor(.gray, for: .normal)
//        $0.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
    }
    
    var underLine = UIView().then {
        $0.backgroundColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func ButtonAction(_ sender: UIButton) {
        let tableView = InfoViewController().tableView
        switch sender {
        case firstButton:
            let indexPath = IndexPath(row: 0, section: 1)
            tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
        case secondButton:
            let indexPath = IndexPath(row: 0, section: 2)
            tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
        default: buttonIndex = 0
        }
            
    }
    
    func setAutoLayout() {
        addSubview(wrap)
        wrap.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 31))
            $0.edges.equalToSuperview()
        }
        
        wrap.addSubview(firstButton)
        firstButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.size.equalTo(CGSize(width: 79, height: 24))
        }
        
        wrap.addSubview(secondButton)
        secondButton.snp.makeConstraints{
            $0.centerY.equalTo(firstButton)
            $0.left.equalTo(firstButton.snp.right).offset(20)
            $0.size.equalTo(CGSize(width: 37, height: 24))
        }
        
//        wrap.addSubview(thirdButton)
//        thirdButton.snp.makeConstraints{
//            $0.centerY.equalTo(firstButton)
//            $0.left.equalTo(secondButton.snp.right).offset(20)
//            $0.size.equalTo(CGSize(width: 56, height: 24))
//        }
        
        wrap.addSubview(underLine)
        underLine.snp.makeConstraints{
            $0.top.equalTo(firstButton.snp.bottom).offset(5)
            $0.left.equalTo(firstButton.snp.left)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 79, height: 4))
        }
    }
    
//    @objc func ButtonAction(_ sender: UIButton) {
//        let tableVC = InfoViewController().tableView
//        switch sender {
//        case firstButton: switchButtonIndex(0)
//        case secondButton: switchButtonIndex(1)
//        case thirdButton:
//            buttonIndex = 2
//            tableVC?.reloadData()
//            UIView.animate(withDuration: 2.0, animations: switchButtonIndex)
//        default: buttonIndex = 0
//            
//        }
//    }
    
    func switchButtonIndex(_ buttonIndex: Int) {
            switch buttonIndex {
                
            case 0:
                print("맛집 추천")
                firstButton.setTitleColor(.black, for: .normal)
                secondButton.setTitleColor(.gray, for: .normal)
//                thirdButton.setTitleColor(.gray, for: .normal)
                
                underLine.snp.updateConstraints{
                    $0.top.equalTo(firstButton.snp.bottom).offset(5)
                    $0.left.equalTo(firstButton.snp.left)
                    $0.bottom.equalToSuperview()
                    $0.size.equalTo(CGSize(width: 79, height: 4))
                }

            case 1:
                print("리뷰")
                firstButton.setTitleColor(.gray, for: .normal)
                secondButton.setTitleColor(.black, for: .normal)
//                thirdButton.setTitleColor(.gray, for: .normal)
                
                underLine.snp.updateConstraints{
                    $0.top.equalTo(firstButton.snp.bottom).offset(5)
                    $0.left.equalTo(firstButton.snp.left).offset(99)
                    $0.bottom.equalToSuperview()
                    $0.size.equalTo(CGSize(width: 37, height: 4))
                }
                InfoViewController().tableView.reloadData()
//            case 2:
//                print("리워드")
//                firstButton.setTitleColor(.gray, for: .normal)
//                secondButton.setTitleColor(.gray, for: .normal)
//                thirdButton.setTitleColor(.black, for: .normal)
//
//                underLine.snp.updateConstraints{
//                    $0.top.equalTo(firstButton.snp.bottom).offset(5)
//                    $0.left.equalTo(firstButton.snp.left).offset(155)
//                    $0.bottom.equalToSuperview()
//                    $0.size.equalTo(CGSize(width: 56, height: 4))
//                }
//                InfoViewController().tableView.reloadData()
            default: // 0 이랑 동일
                print("맛집 추천")
                firstButton.setTitleColor(.black, for: .normal)
                secondButton.setTitleColor(.gray, for: .normal)
//                thirdButton.setTitleColor(.gray, for: .normal)
                
                underLine.snp.remakeConstraints{
                    $0.top.equalTo(firstButton.snp.bottom).offset(5)
                    $0.left.equalToSuperview().inset(16)
                    $0.bottom.equalToSuperview()
                    $0.size.equalTo(CGSize(width: 79, height: 4))
                }
            }
        
    }
}
