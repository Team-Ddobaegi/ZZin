//
//  PostViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//
// section 0. 가게이름, 1. 가게 연락처, 2. 제목, 3. 동반인, 4. 상황별, 5. 음식종류, 6. 리뷰 내용
import UIKit
import Foundation
import SnapKit
import Then
import Photos
import PhotosUI
import FirebaseStorage
import Firebase


var searchedInfo: Document?

class PostViewController: UICollectionViewController, MatchingKeywordDelegate, UITextViewDelegate, SendText {

    // MARK: - Properties
    let instance = SelectKeywordCell()
    var dataWillSet: [String: Any] = [:]
    
    let uid = "bo_bo_@kakao.com"
    var imgData: [Data] = []
    var imgArr: [UIImage] = []
    
    var firstKeywordText = "동반인"
    var secondKeywordText = "특성"
    var menuKeywordText = "식종"
    
    var firstButtonColor: UIColor = .lightGray
    var secondButtonColor: UIColor = .lightGray
    var menuButtonColor: UIColor = .lightGray
    
    
    
    // MARK: - Initializers
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
            self.view.endEditing(true)
      }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload start")
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name:UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        collectionView.reloadData()
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Navigation Bar
        navigationItem.title = "찐 맛집 추천"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Collection View
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = getLayout()
        
        // cell register
        collectionView.register(textInputCell.self, forCellWithReuseIdentifier: textInputCell.identifier)
        collectionView.register(ImgSelectionCell.self, forCellWithReuseIdentifier: ImgSelectionCell.identifier)
        collectionView.register(SelectKeywordCell.self, forCellWithReuseIdentifier: SelectKeywordCell.identifier)
        
        // textView delegate
//        textView.delegate = self
    }
    
    @objc func didFindPlaceButtonTapped(_ sender: Any?) {
        let nextVC = SearchControllerVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension PostViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int{3}
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1: return imgData.count + 1
        default: return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textInputCell.identifier, for: indexPath) as! textInputCell
            cell.findPlaceButton.addTarget(self, action: #selector(didFindPlaceButtonTapped), for: .touchUpInside)
            
            if searchedInfo != nil {
                cell.placeNameField.textField.text = searchedInfo?.placeName
                cell.placeAddressField.textField.text = searchedInfo?.roadAddressName
                cell.placeTelNumField.textField.text = searchedInfo?.phone
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImgSelectionCell.identifier, for: indexPath) as! ImgSelectionCell
            
            cell.layer.cornerRadius = 15
            
            guard !imgData.isEmpty else {
                cell.imageView.image = UIImage(named: "add_photo")
                return cell
            }
            
            switch indexPath.item {
            case 0:
                cell.imageView.image = UIImage(named: "add_photo")
                cell.countLabel.text = String(imgArr.count) + " / 5"
            default:
                cell.imageView.image = imgArr[indexPath.item - 1]
                cell.countLabel.isHidden =  true
            }
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectKeywordCell.identifier, for: indexPath) as! SelectKeywordCell
            cell.firstKeywordButton.setTitle(firstKeywordText, for: .normal)
            cell.firstKeywordButton.setTitleColor(firstButtonColor, for: .normal)
            cell.secondKeywordButton.setTitle(secondKeywordText, for: .normal)
            cell.secondKeywordButton.setTitleColor(secondButtonColor, for: .normal)
            cell.menuKeywordButton.setTitle(menuKeywordText, for: .normal)
            cell.menuKeywordButton.setTitleColor(menuButtonColor, for: .normal)
//            cell.textView = self.textView
//            cell.textView.backgroundColor = .quaternarySystemFill
            
            //버튼기능
            cell.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
            cell.firstKeywordButton.addTarget(self, action: #selector(firstKeywordButtonTapped), for: .touchUpInside)
            cell.secondKeywordButton.addTarget(self, action: #selector(secondKeywordButtonTapped), for: .touchUpInside)
            cell.menuKeywordButton.addTarget(self, action: #selector(menuKeywordButtonTapped), for: .touchUpInside)
            cell.textView.delegate = self
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    @objc func submitButtonTapped() {
        let content = instance.textViewText
        dataWillSet.updateValue(content, forKey: "content")
        print("제출 눌림")
        print(dataWillSet)
    }
    
    func sendText(_ text: String) {
        print("in send text")
        print("text", text)
        dataWillSet.updateValue(text, forKey: "content")
    }
    
    // 첫 번째 키워드 버튼이 탭될 때
    @objc func firstKeywordButtonTapped() {
        print("첫 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .companion
        keywordVC.matchingKeywordView.noticeLabel.text = "누구랑\n가시나요?"
        keywordVC.delegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 두 번째 키워드 버튼이 탭될 때
    @objc func secondKeywordButtonTapped() {
        print("두 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .condition
        keywordVC.matchingKeywordView.noticeLabel.text = "어떤 분위기를\n원하시나요?"
        keywordVC.delegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    // 메뉴 키워드 버튼이 탭될 때
    @objc func menuKeywordButtonTapped() {
        print("메뉴 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .kindOfFood
        keywordVC.matchingKeywordView.noticeLabel.text = "메뉴는\n무엇인가요?"
        keywordVC.delegate = self
        navigationController?.present(keywordVC, animated: true)
    }
    
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType) {
        let keywordType = keywordType
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectKeywordCell.identifier, for: IndexPath(item: 0, section: 2)) as! SelectKeywordCell
        switch keywordType {
        case .companion:
            if let updateKeyword = keyword.first {
                cell.firstKeywordButton.setTitle(updateKeyword, for: .normal)
                cell.firstKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.firstKeywordText = updateKeyword
                self.collectionView.reloadData()
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                cell.secondKeywordButton.setTitle(updateKeyword, for: .normal)
                cell.secondKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.secondKeywordText = updateKeyword
                self.collectionView.reloadData()
            }
            
        case .kindOfFood:
            if let updateKeyword = keyword.first {
                cell.menuKeywordButton.setTitle(updateKeyword, for: .normal)
                cell.menuKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.menuKeywordText = updateKeyword
                self.collectionView.reloadData()
            }
        }
    }
    
    func getLayout() -> UICollectionViewCompositionalLayout {
      UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
        switch section {
        case 1:
            let spacing = CGFloat(16)
          // Item
          let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(126),
            heightDimension: .absolute(110)
          )
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
          
          // Group
          let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(126 * 2),
            heightDimension: .absolute(110)
          )
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
          
          // Section
          let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
          section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: 0)
          return section
        case 2:
            let spacing = CGFloat(16)
            let itemFractionalWidthFraction = 1.0 // horizontal 1개의 셀
          // Item
          let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
            heightDimension: .absolute(550)
          )
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
          
          // Group
          let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(550)
          )
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
          
          // Section
          let section = NSCollectionLayoutSection(group: group)
          section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
          return section
        default:
            let itemFractionalWidthFraction = 1.0 // horizontal 1개의 셀
          let itemInset: CGFloat = 16
          
          // Item
          let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
            heightDimension: .fractionalHeight(1)
          )
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
          item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
          
          // Group
          let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(500)
          )
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
          
          // Section
          let section = NSCollectionLayoutSection(group: group)
          section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
          return section
        }
      }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.item {
            case 0:
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 5
                configuration.filter = .images
                
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            default: return
            }
        }
    }
}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        for (index, _) in results.enumerated() {
           let itemProvider = results[index].itemProvider
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self,
                      let uiImage = image as? UIImage,
                      let data = uiImage.jpegData(compressionQuality: 0.8) else { return }
                
                DispatchQueue.main.sync {
                    self.imgData.append(data)
                    self.imgArr.append(uiImage)
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
}

extension PostViewController {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text as Any)
        dataWillSet.updateValue(textView.text as Any, forKey: "content")
        print(dataWillSet["content"])
    }
}

