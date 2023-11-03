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

        self.dismiss(animated: true)
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
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError("Couldn't find file 'KeyList.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "KAKAO_LOCAL_API_KEY") as? String else {
                fatalError("Couldn't find key 'KAKAO_LOCAL_API_KEY' in 'KeyList.plist'.")
            }
            return value
        }
    }
}

