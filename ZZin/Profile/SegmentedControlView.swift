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
        $0.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
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
        
        wrap.addSubview(thirdButton)
        thirdButton.snp.makeConstraints{
            $0.centerY.equalTo(firstButton)
            $0.left.equalTo(secondButton.snp.right).offset(20)
            $0.size.equalTo(CGSize(width: 56, height: 24))
        }
        
        wrap.addSubview(underLine)
        underLine.snp.makeConstraints{
            $0.top.equalTo(firstButton.snp.bottom).offset(5)
            $0.left.equalTo(firstButton.snp.left)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 79, height: 4))
        }
    }
    
    @objc func ButtonAction(_ sender: UIButton) {
        
        switch sender {
        case firstButton:
            buttonIndex = 0
            UIView.animate(withDuration: 2.0, delay: 1.0, options: .allowAnimatedContent, animations: switchButtonIndex)
        case secondButton:
            buttonIndex = 1
            UIView.animate(withDuration: 2.0, animations: switchButtonIndex)
        case thirdButton:
            buttonIndex = 2
            UIView.animate(withDuration: 2.0, animations: switchButtonIndex)
        default:
            buttonIndex = 0
            UIView.animate(withDuration: 2.0, animations: switchButtonIndex)
        }
    }
    
    func switchButtonIndex() {
            switch buttonIndex {
            case 0:
                print("맛집 추천")
                firstButton.setTitleColor(.black, for: .normal)
                secondButton.setTitleColor(.gray, for: .normal)
                thirdButton.setTitleColor(.gray, for: .normal)
                
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
                thirdButton.setTitleColor(.gray, for: .normal)
                
                underLine.snp.updateConstraints{
                    $0.top.equalTo(firstButton.snp.bottom).offset(5)
                    $0.left.equalTo(firstButton.snp.left).offset(99)
                    $0.bottom.equalToSuperview()
                    $0.size.equalTo(CGSize(width: 37, height: 4))
                }
            case 2:
                print("리워드")
                firstButton.setTitleColor(.gray, for: .normal)
                secondButton.setTitleColor(.gray, for: .normal)
                thirdButton.setTitleColor(.black, for: .normal)
                
                underLine.snp.updateConstraints{
                    $0.top.equalTo(firstButton.snp.bottom).offset(5)
                    $0.left.equalTo(firstButton.snp.left).offset(155)
                    $0.bottom.equalToSuperview()
                    $0.size.equalTo(CGSize(width: 56, height: 4))
                }
            default: // 0 이랑 동일
                print("맛집 추천")
                firstButton.setTitleColor(.black, for: .normal)
                secondButton.setTitleColor(.gray, for: .normal)
                thirdButton.setTitleColor(.gray, for: .normal)
                
                underLine.snp.remakeConstraints{
                    $0.top.equalTo(firstButton.snp.bottom).offset(5)
                    $0.left.equalToSuperview().inset(16)
                    $0.size.equalTo(CGSize(width: 79, height: 4))
                }
            }
        
    }
}

class SegmentedControlHeader: UITableViewHeaderFooterView {

    let segmentedControl = UISegmentedControl(items: ["추천 맛집", "리뷰", "리워드"])
    private lazy var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
            
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSegmentedControl() {
        contentView.addSubview(segmentedControl)
        contentView.addSubview(underLineView)
        
        segmentedControl.selectedSegmentIndex = 0

        let img = UIImage()
        segmentedControl.setBackgroundImage(img, for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(img, for: .selected, barMetrics: .default)
        segmentedControl.setBackgroundImage(img, for: .highlighted, barMetrics: .default)
        
        segmentedControl.setDividerImage(img, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        segmentedControl.addTarget(self, action: #selector(SegmentedControlValueChanged(_:)), for: .valueChanged)
        

        segmentedControl.snp.makeConstraints{
            $0.top.equalToSuperview().inset(35)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(CGSize(width: 280, height: 24))
        }

        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .highlighted)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .focused)
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.height.equalTo(2)
            $0.leading.equalTo(segmentedControl)
            $0.width.equalTo(segmentedControl.snp.width).dividedBy(segmentedControl.numberOfSegments)
        }
        segmentedControl.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
      }
    
    
    @objc func SegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: print("click 0")
        case 1: print("click 1")
        case 2: print("click 2")
        default: print("in method")
        }
    }
    
    @objc private func changeUnderLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
    // leadingDistance는 밑줄의 위치로 segment의 길이(segmentControl아님) * 선택된 segment의 index 위치가 밑줄의 leading이다
    // 예를 들어 segment가 4개가 있고 segment control이 100이라고 하면 각 segment의 길이는 25일 것이고
    // 첫 번째 segment를 선택 했을 때 밑줄의 leading은 0이 되어야 하며 두 번째는 첫번째 segment의 끝
    // 즉 25가 밑줄의 leading이 되어야 한다


    // 아래는 0.3초의 시간 동안 view의 애니메이션을 주면서 밑줄의 constraints를 업데이트 해준다
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
        guard let self = self else {
            return
        }

        self.underLineView.snp.updateConstraints {
            $0.leading.equalTo(self.segmentedControl).inset(leadingDistance)
        }
        self.layoutIfNeeded()
    })
    }
    
}
