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


var placeName: String = ""
var address: String = ""
var mapx: Double = 0
var mapy: Double = 0

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MatchingKeywordDelegate {
    let matchingView = MatchingView()
    let firestore = FireStoreManager.shared
    
    var firstKeywordText = "키워드"
    var secondKeywordText = "키워드"
    var menuKeywordText = "키워드"
    
    var firstButtonColor: UIColor = .lightGray
    var secondButtonColor: UIColor = .lightGray
    var menuButtonColor: UIColor = .lightGray
    
    
    func updateKeywords(keyword: [String], keywordType: MatchingKeywordType) {
        let keywordType = keywordType
        
        switch keywordType {
        case .companion:
            if let updateKeyword = keyword.first {
                print(updateKeyword)
                firstKeywordText = updateKeyword
                dataWillSet.updateValue(firstKeywordText, forKey: "companion")
                firstButtonColor = .darkGray
                self.tableView.reloadData()
            }
            
        case .condition:
            if let updateKeyword = keyword.first {
                print(updateKeyword)
                secondKeywordText = updateKeyword
                dataWillSet.updateValue(secondKeywordText, forKey: "condition")
                secondButtonColor = .darkGray
                self.tableView.reloadData()
            }
            
        case .kindOfFood:
            if let updateKeyword = keyword.first {
                print(updateKeyword)
                menuKeywordText = updateKeyword
                dataWillSet.updateValue(menuKeywordText, forKey: "kindOfFood")
                menuButtonColor = .darkGray
                self.tableView.reloadData()
            }
        }
    }
    
    var tableView = UITableView()
    var imageWillAppear = UIImage(named: "add_photo")
    var dataWillSet: [String: Any?] = [:]
    
    let placeNameTitle = UILabel().then {
        $0.text = "업체명"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    var placeNameLabel = UILabel().then {
        $0.text = "업체명을 먼저 검색해주세요"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    let titleLabel = UILabel().then{
        $0.text = "추천 글 제목"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addObserverForReload()
        setNav()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.searchController?.isActive = false
        
        tableView.reloadData()
    }
    func addObserverForReload() {
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.didDismissDetailNotification(_:)),
                  name: NSNotification.Name("DismissThenViewWillAppear"),
                  object: nil
              )
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
          DispatchQueue.main.async {
              self.tableView.reloadData()
          }
      }
    func setNav() {
        self.navigationItem.title = "찐 맛칩 추천하기"
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .label
        
        // navigationBar 아래의 그림자 지우기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // UISearchBar 설정
        let searchController = UISearchController(searchResultsController: RegionSearchResultController())
        
        searchController.searchBar.placeholder = "등록할 상호명 검색"
        searchController.obscuresBackgroundDuringPresentation = true
        self.navigationItem.searchController?.navigationItem.titleView = searchController.searchBar
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = searchController.searchResultsController as? RegionSearchResultController
        self.navigationItem.searchController = searchController
    }
    
    func setTableView() {
        view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        tableView.backgroundColor = .systemBackground
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PostPlaceInfoCell.self, forCellReuseIdentifier: PostPlaceInfoCell.identifier)
        tableView.register(ImgSelectionTableViewCell.self, forCellReuseIdentifier: ImgSelectionTableViewCell.identifier)
        tableView.register(SelectKeywordsTableViewCell.self, forCellReuseIdentifier: SelectKeywordsTableViewCell.identifier)
        tableView.register(PostPlaceContentCell.self, forCellReuseIdentifier: PostPlaceContentCell.identifier)
        tableView.separatorStyle = .none
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {9}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 50
        case 4: return 50
        case 6: return 280
        case 7: return 160
        case 8: return 280
        default: return 100
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {1}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            let titleLabel = UILabel().then {
                $0.text = "맛집 정보 입력"
                $0.font = .systemFont(ofSize: 25, weight: .bold)
            }
            cell.contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.left.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: IndexPath(row: 0, section: 1)) as! PostTableViewCell
            if placeName != "" {
                cell.textField.text = placeName
            }
            cell.titleLabel.text = "가게 이름"
            cell.textField.placeholder = "상호명을 검색해주세요."
            let text = cell.textFieldDidEndEditing(cell.textField)
            dataWillSet.updateValue(text, forKey: "placeName")
            dataWillSet.updateValue(mapx, forKey: "mapx") // 위도
            dataWillSet.updateValue(mapy, forKey: "mapy") // 경도
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: IndexPath(row: 0, section: 2)) as! PostTableViewCell
            if address != "" {
                cell.textField.text = address
            }
            cell.titleLabel.text = "가게 주소"
            cell.textField.placeholder = "상호명을 검색해주세요."
            let text = cell.textFieldDidEndEditing(cell.textField)
            dataWillSet.updateValue(text, forKey: "address")
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: IndexPath(row: 0, section: 3)) as! PostTableViewCell
            
            cell.titleLabel.text = "가게 연락처"
            cell.textField.placeholder = "연락처 입력"
            let text = cell.textFieldDidEndEditing(cell.textField)
            dataWillSet.updateValue(text, forKey: "placeTelNum")
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = UITableViewCell()
            let titleLabel = UILabel().then {
                $0.text = "리뷰 정보 입력"
                $0.font = .systemFont(ofSize: 25, weight: .bold)
            }
            cell.contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.left.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
            cell.selectionStyle = .none
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: IndexPath(row: 0, section: 5)) as! PostTableViewCell
            cell.textField.placeholder = "리뷰 글 제목 입력"
            cell.titleLabel.text = "제목"
            let text = cell.textFieldDidEndEditing(cell.textField)
            dataWillSet.updateValue(text, forKey: "title")
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ImgSelectionTableViewCell.identifier, for: indexPath) as! ImgSelectionTableViewCell
            cell.addImgButton.setImage(imageWillAppear, for: .normal)
            cell.selectionStyle = .none
            cell.buttonAction = { [self] in
                didTappedAddImgButton()
            }
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectKeywordsTableViewCell.identifier, for: indexPath) as! SelectKeywordsTableViewCell
            cell.firstKeywordButton.setTitle(firstKeywordText, for: .normal)
            cell.firstKeywordButton.setTitleColor(firstButtonColor, for: .normal)
            cell.secondKeywordButton.setTitle(secondKeywordText, for: .normal)
            cell.secondKeywordButton.setTitleColor(secondButtonColor, for: .normal)
            cell.menuKeywordButton.setTitle(menuKeywordText, for: .normal)
            cell.menuKeywordButton.setTitleColor(menuButtonColor, for: .normal)
            
            //버튼기능
            cell.firstKeywordButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
            cell.secondKeywordButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
            cell.menuKeywordButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostPlaceContentCell.identifier, for: indexPath) as! PostPlaceContentCell
            cell.submitButton.addTarget(self, action: #selector(didTappedSubmitButton), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
            
        default: return UITableViewCell()
        }
    }
    @objc func didTappedAddImgButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func firstButtonTapped(_ sender: UIButton) {
        print("첫 번째 키워드 버튼이 탭됨")
        
        let keywordVC = MatchingKeywordVC()
        keywordVC.selectedMatchingKeywordType = .companion
        keywordVC.matchingKeywordView.noticeLabel.text = "누구랑\n가시나요?"
        keywordVC.delegate = self
        
        present(keywordVC, animated: true)
        }
        
        @objc func secondButtonTapped(_ sender: UIButton) {
            print("두 번째 키워드 버튼이 탭됨")
            
            let keywordVC = MatchingKeywordVC()
            keywordVC.selectedMatchingKeywordType = .condition
            keywordVC.matchingKeywordView.noticeLabel.text = "어떤 분위기를\n원하시나요?"
            keywordVC.delegate = self
            
            present(keywordVC, animated: true)
        }
        
        @objc func menuButtonTapped(_ sender: UIButton) {
            print("메뉴 키워드 버튼이 탭됨")
            
            let keywordVC = MatchingKeywordVC()
            keywordVC.selectedMatchingKeywordType = .kindOfFood
            keywordVC.matchingKeywordView.noticeLabel.text = "메뉴는\n무엇인가요?"
            keywordVC.delegate = self
            
           present(keywordVC, animated: true)
        }
        
}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            guard let self = self,
                  let uiImage = image as? UIImage,
                  let data = uiImage.jpegData(compressionQuality: 0.8) else { return }
            
            
            DispatchQueue.main.sync {
                print("count: \(self.dataWillSet.count)")
                self.dataWillSet.updateValue(data, forKey: "imgData")
                self.imageWillAppear = uiImage
                print("count: \(self.dataWillSet.count)")

                self.tableView.reloadData()
            }
        }
    }
    
    @objc func didTappedSubmitButton(_ sender: UIButton) {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: PostPlaceContentCell.identifier) as! PostPlaceContentCell
        
        cell.textViewDidChange(cell.textView){ text in
            let content = text
            dataWillSet.updateValue(content, forKey: "content")
        }
        
        print(String(describing: dataWillSet))
        
        
        firestore.setData(uid: "bo_bo_@kakao.com", dataWillSet: dataWillSet)
        dismiss(animated: true)
        
    }
}
