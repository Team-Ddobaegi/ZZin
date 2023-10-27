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

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView = UITableView()
    
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
        
        setNav()
        setTableView()
    }
    
    func setNav() {
        self.navigationItem.title = "찐 맛칩 추천하기"
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .label
        
        // navigationBar 아래의 그림자 지우기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // UISearchBar 설정
        var searchController = UISearchController(searchResultsController: RegionSearchResultController())
        
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
        case 6: return 250
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
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            
            cell.titleLabel.text = "가게 이름"
            cell.textField.text = placeName
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            
            cell.titleLabel.text = "가게 주소"
            cell.textField.text = address
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            
            cell.titleLabel.text = "가게 연락처"
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
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.textField.placeholder = "제목 입력"
            cell.titleLabel.text = "제목"
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ImgSelectionTableViewCell.identifier, for: indexPath) as! ImgSelectionTableViewCell
            cell.selectionStyle = .none
            cell.buttonAction = { [self] in
                didTappedAddImgButton()
            }
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectKeywordsTableViewCell.identifier, for: indexPath) as! SelectKeywordsTableViewCell
            
            //버튼기능
            cell.firstKeywordButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
            cell.secondKeywordButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
            cell.menuKeywordButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PostPlaceContentCell.identifier, for: indexPath) as! PostPlaceContentCell
        
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
        present(picker, animated: true, completion: nil)
    }
    
    @objc func firstButtonTapped(_ sender: UIButton) {
            let matchingKeywordVC = MatchingKeywordVC()
            matchingKeywordVC.selectedMatchingKeywordType = .with
            matchingKeywordVC.noticeLabel.text = "누구랑\n가시나요?"
            matchingKeywordVC.userChoiceCollectionView.reloadData()  // 첫 번째 키워드로 컬렉션 뷰 로드
            
            navigationController?.present(matchingKeywordVC, animated: true)
        }
        
        @objc func secondButtonTapped(_ sender: UIButton) {
            let matchingKeywordVC = MatchingKeywordVC()
            matchingKeywordVC.selectedMatchingKeywordType = .condition
            matchingKeywordVC.noticeLabel.text = "어떤 분위기를\n원하시나요?"
            matchingKeywordVC.userChoiceCollectionView.reloadData() // 두 번째 키워드로 컬렉션 뷰 로드
            
            navigationController?.present(matchingKeywordVC, animated: true)
        }
        
        @objc func menuButtonTapped(_ sender: UIButton) {
            let matchingKeywordVC = MatchingKeywordVC()
            matchingKeywordVC.selectedMatchingKeywordType = .menu
            matchingKeywordVC.noticeLabel.text = "메뉴는\n무엇인가요?"
            matchingKeywordVC.userChoiceCollectionView.reloadData() // 메뉴 키워드로 컬렉션 뷰 로드
            
            navigationController?.present(matchingKeywordVC, animated: true)
        }
}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            guard let self = self, let uiImage = image as? UIImage, let data = uiImage.jpegData(compressionQuality: 0.8) else { return }
            
            self.uploadToFirebase(data: data)
        }
    }
    
    func uploadToFirebase(data: Data) {
        print("uploadToFirebase")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var imagesRef = storageRef.child("images")
        let imageName = UUID().uuidString
        let storagePath = "gs://zzin-ios-application.appspot.com//images/\(imageName).jpg"
        imagesRef = storage.reference(forURL: storagePath)
    
        // 유일한 파일 이름을 만들기 위해 UUID를 사용
        

        let uploadTask = imagesRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            print("Uh-oh, an error occurred!")
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
            imagesRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                print("Uh-oh, an error occurred! in down")
              return
            }
          }
        }
    }
}
