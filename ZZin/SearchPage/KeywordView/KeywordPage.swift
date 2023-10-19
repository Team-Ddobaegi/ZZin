//
//  KeywordPage.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/19.
//

import UIKit
import SnapKit
import Then

class KeywordPage: UIViewController {
    let sampleTitles: [String] = ["애인이랑👩‍❤️‍👨", "친구랑👯", "부모님이랑👨‍👦", "소개팅🤭", "혼자🙋🏻‍♀️", "단체 회식🍺"]
    
    let noticeLabel = UILabel().then {
        $0.text = "누구랑\n가시나요?"
        $0.font = UIFont.systemFont(ofSize: 25.39, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private var layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 20
    }
    
    private lazy var userChoiceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(KeywordCollectionViewCell.self, forCellWithReuseIdentifier: KeywordCollectionViewCell.reuseIdentifer)
    }
    
    private var infoLabel = UILabel().then {
        $0.text = "보기를 선택해주세요"
        $0.textColor = ColorGuide.main
        $0.font = UIFont.systemFont(ofSize: 12.69, weight: .medium)
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 15.23
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        print("확인 버튼이 눌렸습니다.")
    }

    func configure() {
        view.backgroundColor = .white
        [noticeLabel, userChoiceCollectionView, infoLabel, confirmButton].forEach { view.addSubview($0) }
        setUI()
    }
    
    func setUI() {
        noticeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22.34)
            $0.top.equalToSuperview().offset(31.48)
            $0.height.equalTo(100)
        }
        
        userChoiceCollectionView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(49.84)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(189.91)
            $0.width.equalTo(348.84)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userChoiceCollectionView.snp.bottom).offset(12.25)
            $0.width.equalTo(349)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(userChoiceCollectionView.snp.bottom).offset(56.36)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(348.84)
            $0.height.equalTo(57.89)
        }
    }
}

extension KeywordPage {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension KeywordPage: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (userChoiceCollectionView.frame.width-20)/2, height: 50)
    }
}

extension KeywordPage: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.reuseIdentifer, for: indexPath) as! KeywordCollectionViewCell
        cell.titleButton.setTitle(sampleTitles[indexPath.item], for: .normal)
        return cell
    }
}
