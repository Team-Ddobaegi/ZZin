//
//  PostViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/11.
//
// section 0. 가게이름, 1. 가게 연락처, 2. 제목, 3. 동반인, 4. 상황별, 5. 음식종류, 6. 리뷰 내용
import UIKit

var placeName: String = ""
var address: String = ""

class PostViewController: UITableViewController, UITextFieldDelegate {
    
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
    
    var placeholderLabel = UILabel().then{
        $0.textColor = .systemGroupedBackground
        $0.font = .systemFont(ofSize: 13, weight: .regular)
    }
    
    let textField = UITextField().then {
        $0.frame.size.height = 22                       // 프레임 높이
        $0.borderStyle = .roundedRect                   // 테두리 스타일

        $0.autocorrectionType = .no                     // 자동 수정 활성화 여부
        $0.spellCheckingType = .no                      // 맞춤법 검사 활성화 여부
        $0.autocapitalizationType = .none               // 자동 대문자 활성화 여부

//        $0.placeholder = "이메일 입력"                     // 플레이스 홀더
        $0.clearButtonMode = .always                    // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.clearsOnBeginEditing = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderLabel.snp.updateConstraints {
            $0.centerY.equalTo(textField).offset(-10)
        }
        UIView.animate(withDuration: 1) {
            self.placeholderLabel.font = .systemFont(ofSize: 10)
            self.placeholderLabel.superview?.layoutIfNeeded()        // Textfield의 슈퍼뷰를 업데이트
    //      self.view.layoutIfNeeded()                          // viewcontroller의 뷰를 업데이트 (상황에 맞게 사용)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        placeholderLabel.snp.updateConstraints {
            $0.center.equalTo(textField)
        }
        UIView.animate(withDuration: 0.5) {
            self.placeholderLabel.font = .systemFont(ofSize: 16)
            self.placeholderLabel.superview?.layoutIfNeeded()
    //      self.view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setNav()
    }
    
    func setNav() {
        self.title = "찐 맛칩 추천하기"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .label
        
        // navigationBar 아래의 그림자 지우기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // UISearchBar 설정
        var searchController = UISearchController(searchResultsController: RegionSearchResultController())
        searchController.searchBar.placeholder = "등록할 상호명 검색"
        searchController.obscuresBackgroundDuringPresentation = true
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = searchController.searchResultsController as? RegionSearchResultController
        self.navigationItem.searchController = searchController
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {6}

}


