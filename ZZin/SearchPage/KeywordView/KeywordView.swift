//
//  KeywordPage.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/19.
//

import UIKit
import SnapKit
import Then

class KeywordView: UIViewController {

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setButtonAttribute()
    }
    
    // MARK: - Properties
    
    enum KeywordType {
        case first
        case second
        case menu
    }
    
    var selectedKeywordType: KeywordType = .first

    let firstKeywords = firstKeyword().with

    let secondKeywords = secondKeyword().condition

    let menuKeywords = menuKeyword().menu
    

    let noticeLabel = UILabel().then {
        $0.text = "누구랑\n가시나요?"
        $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
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
    
    var infoLabel = UILabel().then {
        $0.text = "보기를 선택해주세요."
        $0.textColor = ColorGuide.main
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    
    // MARK: - Settings
    
    func setView() {
        view.backgroundColor = .white
        [noticeLabel, userChoiceCollectionView, infoLabel, confirmButton].forEach { view.addSubview($0) }
        setConstraints()
    }
    
    func setButtonAttribute(){
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Actions
    
    // 첫 번째 키워드 버튼이 탭될 때
    @objc func firstKeywordButtonTapped() {
        print("첫 번째 키워드 버튼이 탭됨")
        selectedKeywordType = .first
        userChoiceCollectionView.reloadData() // 첫 번째 키워드로 컬렉션 뷰를 다시 로드
    }
    
    // 두 번째 키워드 버튼이 탭될 때
    @objc func secondKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        selectedKeywordType = .second
        userChoiceCollectionView.reloadData() // 두 번째 키워드로 컬렉션 뷰를 다시 로드
    }
    
    // 메뉴 키워드 버튼이 탭될 때
    @objc func menuKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        selectedKeywordType = .menu
        userChoiceCollectionView.reloadData() // 메뉴 키워드로 컬렉션 뷰를 다시 로드
    }
    
    @objc func confirmButtonTapped() {
        print("확인 버튼이 눌렸습니다.")
        
       
    }
    
    
    // MARK: - ConfigureUI
    
    func setConstraints() {
        noticeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(100)
        }
        
        userChoiceCollectionView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-150)
            $0.leading.equalToSuperview().offset(25)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
    }
}


// MARK: - CollectionView

extension KeywordView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (userChoiceCollectionView.frame.width-20)/2, height: 50)
    }
}

extension KeywordView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return sampleTitles.count
//        return firstKeywords.count
        switch selectedKeywordType {
        case .first:
            return firstKeywords.count
        case .second:
            return secondKeywords.count
        case .menu:
            return menuKeywords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.reuseIdentifer, for: indexPath) as! KeywordCollectionViewCell
//        cell.titleButton.setTitle(firstKeywords[indexPath.item], for: .normal)
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.reuseIdentifer, for: indexPath) as! KeywordCollectionViewCell
        
        switch selectedKeywordType {
        case .first:
            cell.titleButton.setTitle(firstKeywords[indexPath.item], for: .normal)
        case .second:
            cell.titleButton.setTitle(secondKeywords[indexPath.item], for: .normal)
        case .menu:
            cell.titleButton.setTitle(menuKeywords[indexPath.item], for: .normal)
        }
        
        return cell
    }
}
