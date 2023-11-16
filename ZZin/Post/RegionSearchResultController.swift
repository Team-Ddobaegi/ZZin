//
//  RegionSearchResultControllerTableViewController.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/24.
//

import UIKit
import Alamofire
import Foundation
import Then
import SnapKit

class SearchControllerVC: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    let wrapView = UIView()
    
    let imageView = UIImageView().then{
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .systemGray4
    }
    
    let label = UILabel().then{
        $0.text = "검색창에 상호명을 검색해주세요."
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .systemGray4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupUI()
        setNav()
        addObserverForPop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addObserverForPop() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDismissDetailNotification(_:)),
            name: NSNotification.Name("DismissThenPopAgain"),
            object: nil
        )
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func setupUI() {
        view.addSubview(wrapView)
        wrapView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 200, height: 220))
        }
        
        wrapView.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        wrapView.addSubview(label)
        label.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func setNav() {
        self.navigationController?.navigationBar.backgroundColor = .customBackground
        self.title = "맛집 정보 확인"
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        //  navigationBar 아래의 그림자 지우기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // UISearchBar 설정
        let searchController = UISearchController(searchResultsController: RegionSearchResultController())
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.showsSearchResultsController = true
//        searchController.automaticallyShowsSearchResultsController = true
        searchController.becomeFirstResponder()
        searchController.searchBar.placeholder = "등록할 상호명 검색"
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.isActive = true
        self.navigationItem.searchController?.navigationItem.titleView = searchController.searchBar
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = searchController.searchResultsController as? RegionSearchResultController
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.delegate = self
        self.navigationItem.searchController?.searchBar.delegate = self
       
    }
}

class RegionSearchResultController: UITableViewController, UISearchResultsUpdating {
    var resultArray: [Document] = []
    var query: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RegionSearchResultTableViewCell.self, forCellReuseIdentifier: RegionSearchResultTableViewCell.identifier)
    }
    
    // dismiss 후 PostVC의 tableView reload를 위해
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DismissThenViewWillAppear"), object: nil, userInfo: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("DismissThenPopAgain"), object: nil, userInfo: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {1}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch resultArray.count {
        case 0: return 1
        default: return resultArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {70}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch resultArray.count {
        case 0 : return UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegionSearchResultTableViewCell.identifier, for: indexPath) as? RegionSearchResultTableViewCell
            
            cell?.regionLabel.text = resultArray[indexPath.row].placeName
            cell?.descriptionLabel.text = resultArray[indexPath.row].roadAddressName
            
            return cell ?? UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard resultArray.count > 0 else {return}
        
        let selectedPlace: Document = resultArray[indexPath.row]
        searchedInfo = selectedPlace
        fetchRegionCode(longitude: Double(searchedInfo?.x ?? "") ?? 37.5666102, latitude: Double(searchedInfo?.y ?? "") ?? 126.9783881) { regionDocuments in
            guard let documents = regionDocuments else {
                print("행정구역 정보를 가져오는 데 실패했습니다.")
                return
            }
            
            let document = documents[0]
            
            print("시: \(document.region1DepthName.prefix(2))")
            city = String(document.region1DepthName.prefix(2))
            print("구: \(document.region2DepthName)")
            town = String(document.region2DepthName)
        }

        dismiss(animated: true)
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        query = searchController.searchBar.text ?? ""
        requestPlace(query: query){ [self] documents in
            if let documents = documents {
                // 성공적으로 데이터를 받아와서 사용
                resultArray = documents
                self.tableView.reloadData()
            } else {
                // 오류 처리
                print("Failed to fetch place data.")
            }
        }
        print("resultArray", resultArray)
    }
    
    func requestPlace(query: String, completionHandler: @escaping ([Document]?) -> Void) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let params = ["query": query, "page": "1", "size": "15"]
        let restAPIKey = Bundle.main.kakaoRestAPIKey
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: ["Authorization": "KakaoAK \(restAPIKey)"])
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    completionHandler(searchResult.documents)
                } catch {
                    print("JSON Decoding Failure: \(error)")
                    completionHandler(nil)
                }
                
            case .failure(let error):
                print("error : \(error)")
                completionHandler(nil)
            }
        }
    }
    
    func fetchRegionCode(longitude: Double, latitude: Double, completionHandler: @escaping ([RegionDocument]?) -> Void) {
        let url = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"
        let params = ["x": String(longitude), "y": String(latitude)]
        let restAPIKey = Bundle.main.kakaoRestAPIKey

        AF.request(url,
                   method: .get,
                   parameters: params,
                   headers: ["Authorization": "KakaoAK \(restAPIKey)"])
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let regionResult = try decoder.decode(RegionResponse.self, from: data)
                    completionHandler(regionResult.documents)
                } catch {
                    print("JSON Decoding Failure: \(error)")
                    completionHandler(nil)
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }
}

// MARK: - SearchResult
struct SearchResult: Codable {
    let documents: [Document]
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let addressName, categoryGroupCode, categoryGroupName, categoryName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let sameName: SameName
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}

// MARK: - RegionResponse
struct RegionResponse: Codable {
    let meta: RegionMeta
    let documents: [RegionDocument]
}

// MARK: - RegionMeta
struct RegionMeta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

// MARK: - RegionDocument
struct RegionDocument: Codable {
    let regionType, code, addressName, region1DepthName: String
    let region2DepthName, region3DepthName, region4DepthName: String
    let x, y: Double

    enum CodingKeys: String, CodingKey {
        case regionType = "region_type"
        case code
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case region4DepthName = "region_4depth_name"
        case x, y
    }
}

// MARK: - SameName
struct SameName: Codable {
    let keyword: String
    let region: [String]
    let selectedRegion: String

    enum CodingKeys: String, CodingKey {
        case keyword
        case region
        case selectedRegion = "selected_region"
    }
}

extension String {
    // html 태그 제거 + html entity들 디코딩.
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}

extension Bundle {
    var kakaoRestAPIKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "KAKAO_LOCAL_API_KEY") as? String else {
                fatalError("Couldn't find key 'KAKAO_LOCAL_API_KEY' in 'SecretKey.plist'.")
            }
            return value
        }
    }
}

