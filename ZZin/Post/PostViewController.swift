//
//  PostViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//
import UIKit
import Foundation
import SnapKit
import Then
import Photos
import PhotosUI
import FirebaseStorage
import Firebase

var searchedInfo: Document? = nil
var city: String? = nil
var town: String? = nil
var textViewText: String? = ""
var titleText: String? = ""

class PostViewController: UICollectionViewController, MatchingKeywordDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    let storeManager = FireStoreManager.shared
    var dataWillSet: [String: Any] = [:]
//    private var selections = [String: PHPickerResult]()
//    private var selectedAssetIdentifiers = [String]()
    
    let uid = MainViewController().uid!
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
        hideKeyboardWhenTappedAround()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.customBackground
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
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
        self.navigationController?.navigationBar.backgroundColor = .customBackground
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .customBackground
        
        // delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Collection View
        collectionView.backgroundColor = .customBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = getLayout()
        
        // cell register
        collectionView.register(textInputCell.self, forCellWithReuseIdentifier: textInputCell.identifier)
        collectionView.register(ImgSelectionCell.self, forCellWithReuseIdentifier: ImgSelectionCell.identifier)
        collectionView.register(SelectKeywordCell.self, forCellWithReuseIdentifier: SelectKeywordCell.identifier)
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
            } else {
                cell.placeNameField.textField.text = ""
                cell.placeAddressField.textField.text = ""
                cell.placeTelNumField.textField.text = ""
            }
            
            cell.reviewTitleField.textField.text = titleText
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
                print("imgArr.count :", imgArr.count)
                cell.countLabel.text = "\(imgArr.count) / 5"
                cell.countLabel.isHidden =  false
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
            
            if textViewText == "" {
                cell.textView.text = ""
            }
            
            //버튼기능
            cell.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
            cell.firstKeywordButton.addTarget(self, action: #selector(firstKeywordButtonTapped), for: .touchUpInside)
            cell.secondKeywordButton.addTarget(self, action: #selector(secondKeywordButtonTapped), for: .touchUpInside)
            cell.menuKeywordButton.addTarget(self, action: #selector(menuKeywordButtonTapped), for: .touchUpInside)
            
            if searchedInfo != nil && firstKeywordText != "동반인" && secondKeywordText != "특성" && menuKeywordText != "식종" && titleText != nil && textViewText != nil && imgArr.count != 0 {
                cell.submitButton.backgroundColor = ColorGuide.main
                cell.submitButton.isUserInteractionEnabled = true
            }
            print(titleText as Any)
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    @objc func submitButtonTapped() {
        // 저장해야하는 데이터
        
        print("제출 눌림")
//        let titleFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: textInputCell.identifier, for: IndexPath(item: 0, section: 0)) as! textInputCell
        
//        titleText = titleFieldCell.reviewTitleField.text
        
        dataWillSet.updateValue(imgData, forKey: "imgData")
        dataWillSet.updateValue(searchedInfo?.placeName as Any, forKey: "placeName")
        dataWillSet.updateValue(searchedInfo?.placeName as Any, forKey: "placeName")
        dataWillSet.updateValue(searchedInfo?.roadAddressName as Any, forKey: "address")
        dataWillSet.updateValue(searchedInfo?.phone as Any, forKey: "placeTelNum")
        dataWillSet.updateValue(Double(searchedInfo?.y ?? "0")!, forKey: "lat")
        dataWillSet.updateValue(Double(searchedInfo?.x ?? "0")!, forKey: "long")
        dataWillSet.updateValue(firstKeywordText, forKey: "companion")
        dataWillSet.updateValue(secondKeywordText, forKey: "condition")
        dataWillSet.updateValue(menuKeywordText, forKey: "kindOfFood")
        dataWillSet.updateValue(titleText as Any, forKey: "title")
        dataWillSet.updateValue(textViewText as Any, forKey: "content")
        dataWillSet.updateValue(city as Any, forKey: "city")
        dataWillSet.updateValue(town as Any, forKey: "town")
        
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n")
        print("dataWillSet :", dataWillSet)
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n")
        
        storeManager.setData(uid: uid, dataWillSet: dataWillSet)
        DispatchQueue.main.async{
            self.flushAll()
        }
        self.tabBarController?.selectedIndex = 0
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
    
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType, indexPath: [IndexPath]) {
        let keywordType = keywordType
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectKeywordCell.identifier, for: IndexPath(item: 0, section: 2)) as! SelectKeywordCell
        switch keywordType {
        case .companion:
            if let updateKeyword = keyword.first {
                cell.firstKeywordButton.setTitle(updateKeyword, for: .normal)
                cell.firstKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.firstKeywordText = updateKeyword
                collectionView.reloadSections([2])
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                cell.secondKeywordButton.setTitle(updateKeyword, for: .normal)
                cell.secondKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.secondKeywordText = updateKeyword
                collectionView.reloadSections([2])
            }
            
        case .kindOfFood:
            if let updateKeyword = keyword.first {
                cell.menuKeywordButton.setTitle(updateKeyword, for: .normal)
                cell.menuKeywordButton.setTitleColor(.darkGray, for: .normal)
                self.menuKeywordText = updateKeyword
                collectionView.reloadSections([2])
            }
        }
    }
    
    func flushAll() {
        
        print("flushAll 실행")
        searchedInfo = nil
        city = nil
        town = nil
        textViewText = ""
        titleText = ""
        
        firstKeywordText = "동반인"
        secondKeywordText = "특성"
        menuKeywordText = "식종"
        
        dataWillSet = [:]
        imgArr = []
        imgData = []
        
        collectionView.reloadData()
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
                var config = PHPickerConfiguration(photoLibrary: .shared())
                config.selectionLimit = 5
                config.filter = .images
                config.selection = .ordered
//                config.preselectedAssetIdentifiers = selectedAssetIdentifiers
                
                let picker = PHPickerViewController(configuration: config)
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
        
        var dataResults: [Data] = []
        var imgResults: [UIImage] = []
        
        for result in results {
            
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let uiImage = image as? UIImage {
                        let data = uiImage.jpegData(compressionQuality: 0.1)
                        DispatchQueue.main.sync {
                            dataResults.append(data!)
                            imgResults.append(uiImage)
                            self?.imgArr = imgResults
                            self?.imgData = dataResults
                            self?.collectionView.reloadSections([1, 2])
                        }
                    }
                    
                }
            }
        }
        
//        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


